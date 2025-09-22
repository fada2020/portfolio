# Quest 플랫폼을 만들며 얻은 아키텍처 노트

Hybricks를 정비한 뒤 바로 진행한 프로젝트가 **Quest**였습니다. 여러 브랜드가 공유할 학습 플랫폼을 6주 안에 만들어야 했고, 기존 서비스를 복제하는 방식으로는 유지보수가 불가능했습니다.

## 요구사항 요약

- 강사가 새로운 학습 플로우를 시도해도 다른 서비스에 영향이 없어야 함
- 운영팀이 Quest, SuperBuddies, YongClass를 한 대시보드에서 관찰하고 알림을 받을 것
- 파일럿 수업 시작까지 6주

## 플랫폼 우선 설계

| 레이어 | 역할 | 구현 |
| --- | --- | --- |
| Presentation | 브랜드별 UI | Next.js 웹, 기존 앱 래퍼 |
| Service | 수업/평가/메시징 도메인 | Spring Boot 서비스 + 개별 모듈 |
| Core Platform | 인증, 결제, 콘텐츠 메타, 알림 | 내부 Maven 아티팩트 `platform-core` |

플랫폼 코어는 도메인 이벤트와 인터페이스만 제공하고 구체 구현은 서비스에서 담당하게 했습니다.

```kotlin
interface LessonPlanService {
    fun generateFlow(request: LessonPlanRequest): LessonPlan
}

interface BillingGateway {
    fun charge(subscriptionId: String, amount: Money): BillingResult
}
```

공유 모듈을 순수 인터페이스로 유지하자 Quest와 SuperBuddies가 각자 구현을 제공하면서도 같은 테스트 세트를 돌릴 수 있었습니다.

## 롤아웃과 관측

- 레슨 완료 퍼널: Kinesis → Athena로 코호트 분석
- SLO 모니터링: 도메인 이벤트 기반 CloudWatch Composite Alarm
- 결제 지연 알림: SNS → Lambda → Slack

Quest 안정화 후 SuperBuddies도 두 스프린트 만에 플랫폼을 도입했습니다.

## 배운 점

1. **플랫폼도 제품이다.** 백로그, 버전, 릴리스 노트를 관리해야 지속 가능하다.
2. **통합 포인트는 작게.** 인터페이스만 공유하고 나머지는 각 서비스가 결정하게 한다.
3. **초기부터 관측성 확보.** 계약마다 알람을 붙여야 리팩터링이 쉬워진다.

Quest는 단순히 새 서비스를 만든 것이 아니라, 이후 브랜드를 위한 공통 기반을 마련한 프로젝트였습니다.
