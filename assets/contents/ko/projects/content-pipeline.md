## 콘텐츠 파이프라인 (YAML/Markdown)

콘텐츠는 다음과 같이 정적 파일로 관리합니다:

- YAML 인덱스: projects.yaml, posts.yaml, profile.yaml
- 로케일별 Markdown 본문 저장
- 런타임 로더가 YAML/MD를 파싱해 위젯에 바인딩

장점: 버전 관리, 쉬운 작성, 테스트 가능한 결정적 렌더링.

