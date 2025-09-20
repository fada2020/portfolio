# Database Performance Optimization: From 30s to 300ms

How we reduced query response time by 99% through systematic database optimization. This is a real-world case study from a high-traffic e-commerce platform.

## The Problem

Our order analytics dashboard was taking 30+ seconds to load, causing timeouts and poor user experience. The main culprit was a complex aggregation query joining multiple tables.

```sql
-- Original problematic query
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

**Query plan analysis showed**:
- Sequential scans on large tables (2M+ orders, 10M+ order_items)
- No indexes on filtered columns
- Expensive hash joins
- Sorting 365 days worth of data

## Step 1: Index Optimization

**Analysis**: Used `EXPLAIN ANALYZE` to identify missing indexes.

```sql
-- Added compound indexes
CREATE INDEX CONCURRENTLY idx_orders_status_created_customer
ON orders (status, created_at, customer_id)
WHERE status = 'completed';

CREATE INDEX CONCURRENTLY idx_customers_type
ON customers (customer_type)
WHERE customer_type = 'premium';

CREATE INDEX CONCURRENTLY idx_order_items_order_product
ON order_items (order_id, product_id);
```

**Result**: Query time reduced from 30s to 8s (73% improvement).

## Step 2: Query Rewriting

**Problem**: Complex joins were still expensive.

**Solution**: Broke down the query and used subqueries with better join order.

```sql
-- Optimized query with CTEs
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

**Result**: Query time reduced from 8s to 2s (75% additional improvement).

## Step 3: Materialized Views

**Problem**: Daily aggregations were recalculated on every request.

**Solution**: Pre-compute daily metrics using materialized views.

```sql
-- Create materialized view for daily metrics
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

-- Create index on materialized view
CREATE INDEX idx_daily_metrics_date_status_type
ON daily_order_metrics (date, status, customer_type);

-- Refresh strategy
CREATE OR REPLACE FUNCTION refresh_daily_metrics()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY daily_order_metrics;
END;
$$ LANGUAGE plpgsql;
```

**Refresh schedule**: Every hour via cron job.

```sql
-- Simple query against materialized view
SELECT * FROM daily_order_metrics
WHERE status = 'completed'
  AND customer_type = 'premium'
ORDER BY date DESC;
```

**Result**: Query time reduced from 2s to 300ms (85% additional improvement).

## Step 4: Connection Pooling

**Problem**: Connection overhead and resource exhaustion.

**Solution**: Implemented PgBouncer for connection pooling.

```ini
# pgbouncer.ini
[databases]
ecommerce = host=localhost port=5432 dbname=ecommerce

[pgbouncer]
pool_mode = transaction
listen_port = 6432
listen_addr = *
auth_type = md5
auth_file = userlist.txt
logfile = pgbouncer.log
pidfile = pgbouncer.pid
admin_users = admin
stats_users = stats, admin
max_client_conn = 1000
default_pool_size = 20
min_pool_size = 5
reserve_pool_size = 5
server_reset_query = DISCARD ALL
```

**Result**: Reduced connection overhead and improved concurrent performance.

## Step 5: Application-Level Caching

**Problem**: Even 300ms queries were too slow for real-time dashboards.

**Solution**: Redis caching with smart invalidation.

```go
type MetricsCache struct {
    redis  *redis.Client
    db     *sql.DB
    ttl    time.Duration
}

func (mc *MetricsCache) GetDailyMetrics(customerType string, days int) ([]DailyMetric, error) {
    cacheKey := fmt.Sprintf("daily_metrics:%s:%d", customerType, days)

    // Try cache first
    cached, err := mc.redis.Get(cacheKey).Result()
    if err == nil {
        var metrics []DailyMetric
        json.Unmarshal([]byte(cached), &metrics)
        return metrics, nil
    }

    // Cache miss - query database
    metrics, err := mc.queryDailyMetrics(customerType, days)
    if err != nil {
        return nil, err
    }

    // Cache for 1 hour
    data, _ := json.Marshal(metrics)
    mc.redis.Set(cacheKey, data, mc.ttl)

    return metrics, nil
}

// Invalidate cache when new orders are processed
func (mc *MetricsCache) InvalidateMetrics(date time.Time) {
    pattern := fmt.Sprintf("daily_metrics:*")
    keys, _ := mc.redis.Keys(pattern).Result()
    if len(keys) > 0 {
        mc.redis.Del(keys...)
    }
}
```

**Result**: 99% of requests served from cache in <10ms.

## Performance Monitoring

**Implemented comprehensive monitoring**:

```go
// Metrics collection
type QueryMetrics struct {
    Duration    time.Duration
    QueryType   string
    CacheHit    bool
    RowsReturned int
}

func (m *QueryMetrics) RecordQuery(start time.Time, queryType string, cacheHit bool, rows int) {
    duration := time.Since(start)

    // Prometheus metrics
    queryDurationHistogram.WithLabelValues(queryType).Observe(duration.Seconds())
    queryCacheHitCounter.WithLabelValues(queryType, fmt.Sprintf("%t", cacheHit)).Inc()

    // Log slow queries
    if duration > 1*time.Second {
        log.Warn("Slow query detected",
            "type", queryType,
            "duration", duration,
            "cache_hit", cacheHit,
            "rows", rows)
    }
}
```

## Results Summary

| Optimization Stage | Response Time | Improvement |
|-------------------|---------------|-------------|
| Original          | 30s           | Baseline    |
| Index optimization| 8s            | 73%         |
| Query rewriting   | 2s            | 93%         |
| Materialized views| 300ms         | 99%         |
| Application cache | <10ms         | 99.97%      |

## Key Learnings

1. **Measure before optimizing**: Use `EXPLAIN ANALYZE` to understand actual query execution
2. **Index strategically**: Compound indexes can eliminate multiple table scans
3. **Pre-compute when possible**: Materialized views for complex aggregations
4. **Cache at the right level**: Application-level caching for frequently accessed data
5. **Monitor continuously**: Track query performance and cache hit rates

## Tools Used

- **PostgreSQL**: `EXPLAIN ANALYZE`, `pg_stat_statements`
- **Monitoring**: Prometheus + Grafana for metrics
- **Caching**: Redis for application-level cache
- **Connection pooling**: PgBouncer
- **Load testing**: Artillery.js for performance validation

## Next Steps

- Implementing read replicas for analytics workloads
- Exploring columnar storage (PostgreSQL + Citus) for time-series data
- Building automated query optimization suggestions

The key is systematic optimization: measure, optimize, measure again. Small changes can have massive impact when applied strategically.