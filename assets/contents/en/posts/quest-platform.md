# Shipping Quest: A Shared Learning Platform

After modernising Hybricks we were asked to launch **Quest**, a personalised learning service that should reuse authentication, payments, and content tools across multiple brands. Instead of cloning the previous codebase we designed Quest as the first consumer of a shared platform.

## Product constraints

- Course authors wanted to experiment with new lesson flows without touching legacy code.
- Operations needed one dashboard to observe Quest, SuperBuddies, and YongClass.
- We had six weeks before the pilot class started.

## Platform-first architecture

| Layer | Responsibility | Implementation |
| --- | --- | --- |
| Presentation | Brand-specific UI | Next.js for web, native wrappers for mobile |
| Service | Course sequencing, assessments, teacher messaging | Spring Boot services talking to a shared domain library |
| Core platform | Auth, billing, content metadata, notifications | Separate Spring Boot module packaged as an internal Maven artefact |

By treating the platform as its own product we avoided circular dependencies. Each service imported a single `platform-core` package that exposed interfaces and domain events.

## Reusable domain modules

```kotlin
interface LessonPlanService {
    fun generateFlow(request: LessonPlanRequest): LessonPlan
}

interface BillingGateway {
    fun charge(subscriptionId: String, amount: Money): BillingResult
}
```

Concrete implementations lived inside Quest, while SuperBuddies provided their own versions during integration. The result: the shared module shipped with 85% unit test coverage and no knowledge about presentation concerns.

## Rollout & telemetry

Quest launched with feature flags for every new flow. We instrumented:

- Lesson completion funnel (Kinesis + Athena for cohort analysis)
- Cross-service SLOs (CloudWatch composite alarms per domain event)
- Slack alerts on delayed billing events (SNS → Lambda → Slack)

Once Quest stabilised, SuperBuddies adopted the same platform within two sprints—proof that the extra upfront architecture paid off.

## Lessons learned

1. **Own your platform as a product.** Document its backlog, version it, and publish release notes.
2. **Keep integration small.** Shared modules expose pure interfaces; each service decides how to wire them.
3. **Invest in telemetry early.** It is easier to refactor when every cross-service contract has an alarm.

Quest didn’t just launch another learning app—it gave us a composable foundation for future brands.
