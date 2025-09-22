# Flutter WebView로 자사 서비스를 하나의 앱으로

2024년 여름 마케팅팀은 “모든 학습 서비스를 담은 하나의 앱”을 요구했습니다. 네 개의 웹 서비스를 native로 다시 만드는 것은 불가능했기에, **Flutter WebView 쉘**로 빠르게 통합 앱을 만들었습니다.

## 왜 WebView 쉘인가?

- 이미 반응형 웹이 존재했고, 오프라인 기능은 필수 요구가 아니었습니다.
- 앱 스토어 입점이 우선 과제였습니다.
- 일정은 4주.

Flutter는 단일 코드베이스, 빠른 UI 반복, 네이티브 브리지 구현에 충분한 유연성을 제공했습니다.

## 구조 한눈에 보기

```dart
class ShellApp extends StatefulWidget { ... }

class _ShellAppState extends State<ShellApp> {
  final _tabs = const [
    WebTab(title: 'Hybricks', url: 'https://hybricks.example.com'),
    WebTab(title: 'Quest', url: 'https://quest.example.com'),
    WebTab(title: 'SuperBuddies', url: 'https://super.example.com'),
    WebTab(title: 'YongClass', url: 'https://yong.example.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebShell(tabs: _tabs),
    );
  }
}
```

각 탭은 `WebViewController`를 감싸고, 간단한 JavaScript 브리지를 통해 공유하기, 인앱 브라우저 열기 같은 네이티브 기능을 제공합니다.

## 배포 체크리스트

1. **딥링크 라우터**: `/deeplink?target=quest#/courses/123` 형태를 탭과 경로에 매핑.
2. **통합 SSO**: 공통 로그인 페이지에서 인증 후 WebView 쿠키를 동기화.
3. **캐싱 정책**: 정적 리소스는 서비스 워커가 처리하고, 쉘은 네비게이션 상태만 기억.
4. **CI/CD**: GitHub Actions가 빌드 → Firebase Test Lab 테스트 → 스토어 업로드까지 자동화.

## 결과

- 두 명의 엔지니어가 4주 만에 출시.
- “어떤 앱을 깔아야 하나요?”라는 고객 문의가 사라졌습니다.
- 마케팅은 하나의 스토어 링크에 딥링크 파라미터만 붙이면 캠페인을 진행할 수 있습니다.

WebView 쉘도 결국 서비스입니다. 브리지 기능, 스토어 정책, 모니터링을 backlog로 관리하면서 안정적으로 운영하고 있습니다.
