# Microservices Design Patterns: Lessons from Production

Building scalable microservices requires more than just splitting a monolith. Here are the key patterns I've learned from implementing and maintaining production microservices.

## 1. API Gateway Pattern

**Problem**: Managing cross-cutting concerns across multiple services.

**Solution**: Centralized gateway handling authentication, rate limiting, and routing.

```go
// Example: Rate limiting middleware
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

**Benefits**:
- Reduced client complexity
- Centralized security policies
- Better monitoring and analytics

## 2. Circuit Breaker Pattern

**Problem**: Cascading failures when downstream services fail.

**Solution**: Fail fast and provide fallback responses.

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

func (cb *CircuitBreaker) Execute(req func() (interface{}, error)) (interface{}, error) {
    generation, err := cb.beforeRequest()
    if err != nil {
        return nil, err
    }

    defer func() {
        e := recover()
        if e != nil {
            cb.afterRequest(generation, false)
            panic(e)
        }
    }()

    result, err := req()
    cb.afterRequest(generation, err == nil)
    return result, err
}
```

**Real-world impact**: Reduced 99th percentile latency from 30s to 500ms during service failures.

## 3. Saga Pattern for Distributed Transactions

**Problem**: ACID transactions across multiple services.

**Solution**: Orchestrated or choreographed sagas with compensation.

```yaml
# Example: Order processing saga
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

**Lessons learned**:
- Always design compensation actions first
- Use idempotent operations
- Implement proper monitoring and alerting

## 4. Event Sourcing for Audit and Recovery

**Problem**: Debugging complex state changes across services.

**Solution**: Store events instead of current state.

```go
type Event struct {
    ID        string    `json:"id"`
    Type      string    `json:"type"`
    Data      []byte    `json:"data"`
    Timestamp time.Time `json:"timestamp"`
    Version   int       `json:"version"`
}

type EventStore interface {
    Append(streamID string, events []Event) error
    Load(streamID string, fromVersion int) ([]Event, error)
}
```

**Benefits**:
- Complete audit trail
- Easy debugging and replay
- Support for CQRS patterns

## Performance Considerations

**Database per Service**:
- Chose PostgreSQL for ACID requirements
- Redis for caching and sessions
- Elasticsearch for search functionality

**Communication Patterns**:
- Synchronous: gRPC for low-latency internal calls
- Asynchronous: Apache Kafka for event streaming
- REST APIs for client-facing endpoints

## Monitoring and Observability

```yaml
# Prometheus metrics example
http_requests_total:
  type: counter
  labels: [method, endpoint, status_code]

http_request_duration_seconds:
  type: histogram
  labels: [method, endpoint]
  buckets: [0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0]
```

**Key metrics to track**:
- Request latency (p50, p95, p99)
- Error rates by service
- Circuit breaker state changes
- Database connection pool usage

## Lessons Learned

1. **Start with a monolith**: Premature optimization leads to distributed monoliths
2. **Design for failure**: Everything will fail, plan accordingly
3. **Invest in tooling**: Good observability saves weeks of debugging
4. **Gradual migration**: Strangler Fig pattern for legacy systems
5. **Team boundaries**: Conway's Law is real - align services with team structure

## Next Steps

- Implementing service mesh (Istio) for advanced traffic management
- Exploring serverless patterns for event-driven workflows
- Building chaos engineering practices

The key to successful microservices is balancing complexity with business value. Each pattern should solve a real problem, not add unnecessary abstraction.