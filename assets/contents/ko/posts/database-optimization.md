# 데이터베이스 성능 최적화: 30초에서 300ms로

체계적인 데이터베이스 최적화를 통해 쿼리 응답 시간을 99% 단축시킨 방법. 고트래픽 이커머스 플랫폼의 실제 사례 연구입니다.

## 문제 상황

주문 분석 대시보드 로딩에 30초 이상이 걸려 타임아웃과 사용자 경험 저하가 발생했습니다. 주요 원인은 여러 테이블을 조인하는 복잡한 집계 쿼리였습니다.

```sql
-- 원래 문제가 된 쿼리
SELECT
    DATE_TRUNC('day', o.created_at) as date,
    COUNT(*) as order_count,
    SUM(o.total_amount) as revenue,
    AVG(o.total_amount) as avg_order_value,
    COUNT(DISTINCT o.customer_id) as unique_customers
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
JOIN customers c ON o.customer_id = c.id
WHERE o.created_at >= '2024-01-01'
  AND o.status = 'completed'
  AND c.customer_type = 'premium'
GROUP BY DATE_TRUNC('day', o.created_at)
ORDER BY date DESC;
```

**쿼리 계획 분석 결과**:
- 대용량 테이블의 순차 스캔 (200만+ 주문, 1000만+ 주문 항목)
- 필터링 컬럼에 인덱스 없음
- 비용이 많이 드는 해시 조인
- 365일치 데이터 정렬

## 1단계: 인덱스 최적화

**분석**: `EXPLAIN ANALYZE`를 사용하여 누락된 인덱스 식별

```sql
-- 복합 인덱스 추가
CREATE INDEX CONCURRENTLY idx_orders_status_created_customer
ON orders (status, created_at, customer_id)
WHERE status = 'completed';

CREATE INDEX CONCURRENTLY idx_customers_type
ON customers (customer_type)
WHERE customer_type = 'premium';

CREATE INDEX CONCURRENTLY idx_order_items_order_product
ON order_items (order_id, product_id);
```

**결과**: 쿼리 시간이 30초에서 8초로 단축 (73% 개선)

## 2단계: 쿼리 재작성

**문제**: 복잡한 조인이 여전히 비용이 많이 듦

**해결책**: 쿼리를 분해하고 더 나은 조인 순서로 서브쿼리 사용

```sql
-- CTE를 사용한 최적화된 쿼리
WITH premium_customers AS (
    SELECT id FROM customers
    WHERE customer_type = 'premium'
),
completed_orders AS (
    SELECT
        o.id,
        o.created_at,
        o.total_amount,
        o.customer_id
    FROM orders o
    INNER JOIN premium_customers pc ON o.customer_id = pc.id
    WHERE o.created_at >= '2024-01-01'
      AND o.status = 'completed'
)
SELECT
    DATE_TRUNC('day', co.created_at) as date,
    COUNT(*) as order_count,
    SUM(co.total_amount) as revenue,
    AVG(co.total_amount) as avg_order_value,
    COUNT(DISTINCT co.customer_id) as unique_customers
FROM completed_orders co
GROUP BY DATE_TRUNC('day', co.created_at)
ORDER BY date DESC;
```

**결과**: 쿼리 시간이 8초에서 2초로 단축 (추가 75% 개선)

## 3단계: 구체화된 뷰(Materialized Views)

**문제**: 일일 집계가 매 요청마다 재계산됨

**해결책**: 구체화된 뷰를 사용하여 일일 지표 사전 계산

```sql
-- 일일 지표를 위한 구체화된 뷰 생성
CREATE MATERIALIZED VIEW daily_order_metrics AS
SELECT
    DATE_TRUNC('day', o.created_at) as date,
    COUNT(*) as order_count,
    SUM(o.total_amount) as revenue,
    AVG(o.total_amount) as avg_order_value,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    o.status,
    c.customer_type
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE o.created_at >= '2024-01-01'
GROUP BY DATE_TRUNC('day', o.created_at), o.status, c.customer_type;

-- 구체화된 뷰에 인덱스 생성
CREATE INDEX idx_daily_metrics_date_status_type
ON daily_order_metrics (date, status, customer_type);
```

**새로고침 일정**: cron 작업을 통해 매시간

```sql
-- 구체화된 뷰에 대한 간단한 쿼리
SELECT * FROM daily_order_metrics
WHERE status = 'completed'
  AND customer_type = 'premium'
ORDER BY date DESC;
```

**결과**: 쿼리 시간이 2초에서 300ms로 단축 (추가 85% 개선)

## 4단계: 연결 풀링

**문제**: 연결 오버헤드와 리소스 고갈

**해결책**: 연결 풀링을 위한 PgBouncer 구현

```ini
# pgbouncer.ini
[databases]
ecommerce = host=localhost port=5432 dbname=ecommerce

[pgbouncer]
pool_mode = transaction
listen_port = 6432
max_client_conn = 1000
default_pool_size = 20
```

**결과**: 연결 오버헤드 감소 및 동시 성능 향상

## 5단계: 애플리케이션 레벨 캐싱

**문제**: 300ms 쿼리도 실시간 대시보드에는 너무 느림

**해결책**: 스마트 무효화가 있는 Redis 캐싱

```go
type MetricsCache struct {
    redis  *redis.Client
    db     *sql.DB
    ttl    time.Duration
}

func (mc *MetricsCache) GetDailyMetrics(customerType string, days int) ([]DailyMetric, error) {
    cacheKey := fmt.Sprintf("daily_metrics:%s:%d", customerType, days)

    // 먼저 캐시 확인
    cached, err := mc.redis.Get(cacheKey).Result()
    if err == nil {
        var metrics []DailyMetric
        json.Unmarshal([]byte(cached), &metrics)
        return metrics, nil
    }

    // 캐시 미스 - 데이터베이스 쿼리
    metrics, err := mc.queryDailyMetrics(customerType, days)
    if err != nil {
        return nil, err
    }

    // 1시간 동안 캐시
    data, _ := json.Marshal(metrics)
    mc.redis.Set(cacheKey, data, mc.ttl)

    return metrics, nil
}
```

**결과**: 99%의 요청이 10ms 미만으로 캐시에서 처리됨

## 성능 모니터링

**포괄적인 모니터링 구현**:

```go
type QueryMetrics struct {
    Duration    time.Duration
    QueryType   string
    CacheHit    bool
    RowsReturned int
}

func (m *QueryMetrics) RecordQuery(start time.Time, queryType string, cacheHit bool, rows int) {
    duration := time.Since(start)

    // Prometheus 지표
    queryDurationHistogram.WithLabelValues(queryType).Observe(duration.Seconds())
    queryCacheHitCounter.WithLabelValues(queryType, fmt.Sprintf("%t", cacheHit)).Inc()

    // 느린 쿼리 로깅
    if duration > 1*time.Second {
        log.Warn("느린 쿼리 감지",
            "type", queryType,
            "duration", duration,
            "cache_hit", cacheHit,
            "rows", rows)
    }
}
```

## 결과 요약

| 최적화 단계 | 응답 시간 | 개선율 |
|------------|----------|--------|
| 원본       | 30초     | 기준    |
| 인덱스 최적화| 8초      | 73%    |
| 쿼리 재작성 | 2초      | 93%    |
| 구체화된 뷰| 300ms    | 99%    |
| 애플리케이션 캐시| <10ms | 99.97% |

## 핵심 학습 내용

1. **최적화 전 측정**: `EXPLAIN ANALYZE`로 실제 쿼리 실행 이해
2. **전략적 인덱싱**: 복합 인덱스로 여러 테이블 스캔 제거
3. **가능한 경우 사전 계산**: 복잡한 집계를 위한 구체화된 뷰
4. **적절한 레벨에서 캐싱**: 자주 액세스되는 데이터를 위한 애플리케이션 레벨 캐싱
5. **지속적 모니터링**: 쿼리 성능과 캐시 적중률 추적

체계적인 최적화가 핵심입니다: 측정, 최적화, 다시 측정. 전략적으로 적용하면 작은 변화가 큰 영향을 가져올 수 있습니다.