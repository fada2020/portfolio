# Architecture

- Migrated from Nginx + Lua scripts to Spring Boot + Netty.
- Introduced token introspection cache (Redis), circuit breakers, and backpressure.

## Trade-offs
- Pros: Observability, typed configs, zero-downtime rollouts via blue/green.
- Cons: Slightly higher baseline CPU at low traffic.

## Metrics
- p98 latency: 210ms → 132ms
- Error rate: 0.7% → 0.2%

## Retrospective
- Invest early in load tests and traffic shadowing; it pays off.
