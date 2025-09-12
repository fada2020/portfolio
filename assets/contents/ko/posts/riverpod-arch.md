# Flutter Web에서 Riverpod를 쓰는 이유

- BuildContext와 분리되어 테스트가 쉽습니다.
- 세분화된 프로바이더로 필요한 부분만 리빌드.
- 비동기 패턴이 콘텐츠 로딩/캐시와 잘 맞습니다.

## 패턴
- 콘텐츠는 FutureProvider, 필터는 StateNotifier.
- 기능별로 프로바이더를 모듈화합니다.

## 예시
```dart
final projectsProvider = FutureProvider((ref) async => loadProjects('ko'));
```
