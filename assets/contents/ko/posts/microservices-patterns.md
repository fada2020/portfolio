# 마이크로서비스 디자인 패턴: 프로덕션에서의 경험

확장 가능한 마이크로서비스를 구축하는 것은 단순히 모놀리스를 분할하는 것 이상입니다. 프로덕션 마이크로서비스를 구현하고 유지보수하면서 학습한 핵심 패턴들을 공유합니다.

## 1. API Gateway 패턴

**문제**: 여러 서비스에 걸친 공통 관심사 관리

**해결책**: 인증, 속도 제한, 라우팅을 처리하는 중앙 집중식 게이트웨이

```go
// 예시: 속도 제한 미들웨어
func RateLimitMiddleware(requests int, window time.Duration) func(http.Handler) http.Handler {
    limiter := rate.NewLimiter(rate.Every(window/time.Duration(requests)), requests)
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            if !limiter.Allow() {
                http.Error(w, "Rate limit exceeded", http.StatusTooManyRequests)
                return
            }
            next.ServeHTTP(w, r)
        })
    }
}
```

**장점**:
- 클라이언트 복잡성 감소
- 중앙 집중식 보안 정책
- 향상된 모니터링 및 분석

## 2. Circuit Breaker 패턴

**문제**: 다운스트림 서비스 장애 시 연쇄 장애

**해결책**: 빠른 실패와 폴백 응답 제공

```go
type CircuitBreaker struct {
    maxRequests uint32
    interval    time.Duration
    timeout     time.Duration
    onStateChange func(name string, from State, to State)

    mutex      sync.Mutex
    name       string
    state      State
    generation uint64
    counts     Counts
    expiry     time.Time
}
```

**실제 효과**: 서비스 장애 시 99퍼센타일 지연시간을 30초에서 500ms로 단축

## 3. 분산 트랜잭션을 위한 Saga 패턴

**문제**: 여러 서비스에 걸친 ACID 트랜잭션

**해결책**: 보상 작업이 있는 오케스트레이션 또는 코레오그래피 사가

```yaml
# 예시: 주문 처리 사가
steps:
  - name: reserve_inventory
    service: inventory-service
    compensation: release_inventory
  - name: charge_payment
    service: payment-service
    compensation: refund_payment
  - name: create_shipment
    service: shipping-service
    compensation: cancel_shipment
```

**배운 점**:
- 항상 보상 작업을 먼저 설계
- 멱등성 연산 사용
- 적절한 모니터링과 알림 구현

## 4. 감사 및 복구를 위한 Event Sourcing

**문제**: 서비스 간 복잡한 상태 변경 디버깅

**해결책**: 현재 상태 대신 이벤트 저장

```go
type Event struct {
    ID        string    `json:"id"`
    Type      string    `json:"type"`
    Data      []byte    `json:"data"`
    Timestamp time.Time `json:"timestamp"`
    Version   int       `json:"version"`
}
```

**장점**:
- 완전한 감사 추적
- 쉬운 디버깅과 재생
- CQRS 패턴 지원

## 성능 고려사항

**서비스별 데이터베이스**:
- ACID 요구사항을 위한 PostgreSQL
- 캐싱과 세션을 위한 Redis
- 검색 기능을 위한 Elasticsearch

**통신 패턴**:
- 동기식: 저지연 내부 호출을 위한 gRPC
- 비동기식: 이벤트 스트리밍을 위한 Apache Kafka
- 클라이언트 대면 엔드포인트를 위한 REST API

## 모니터링 및 관찰가능성

**추적해야 할 핵심 지표**:
- 요청 지연시간 (p50, p95, p99)
- 서비스별 오류율
- Circuit breaker 상태 변경
- 데이터베이스 연결 풀 사용량

## 배운 교훈

1. **모놀리스로 시작**: 성급한 최적화는 분산 모놀리스로 이어짐
2. **장애를 고려한 설계**: 모든 것은 실패하므로 그에 맞는 계획 수립
3. **도구에 투자**: 좋은 관찰가능성은 몇 주의 디버깅 시간을 절약
4. **점진적 마이그레이션**: 레거시 시스템을 위한 Strangler Fig 패턴
5. **팀 경계**: Conway의 법칙은 실제 - 서비스를 팀 구조와 일치시키기

성공적인 마이크로서비스의 핵심은 복잡성과 비즈니스 가치의 균형입니다. 각 패턴은 불필요한 추상화가 아닌 실제 문제를 해결해야 합니다.