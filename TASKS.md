# 백엔드 포트폴리오 개발 태스크 플랜

상태: [ ] TODO  [~] 진행중  [x] 완료

## 0. 환경 준비
- [ ] Flutter 3.x 설치 및 의존성: `flutter --version`, `flutter pub get`
- [ ] 분석/포맷 훅: `flutter analyze`, `dart format .` CI에서 강제

## 1. 정보 구조(IA)와 라우팅
- [ ] 라우팅 스켈레톤(go_router): `/`, `/projects`, `/projects/:id`, `/api`, `/blog`, `/resume`, `/contact`
- [ ] 기본 테마/레이아웃(AppBar/Footer/Responsive Breakpoints)

## 2. 국제화(i18n)
- [ ] 의존성/설정: `flutter_localizations` 활성화, `l10n.yaml` 구성, `lib/l10n/app_en.arb`, `app_ko.arb`
- [ ] `MaterialApp`에 `localizationsDelegates`, `supportedLocales` 적용, 기본/브라우저 언어 감지
- [ ] 언어 전환 토글(UI) + 사용자 선택 로컬 저장(LocalStorage)
- [ ] URL 쿼리(`?lang=ko|en`) 파싱 및 라우팅 연동(선택)
- [ ] 콘텐츠 다국어: `assets/contents/{ko,en}/...` 구조로 분리

## 3. 콘텐츠 스키마와 로더
- [ ] 모델 정의: `lib/models/{project,post,profile}.dart`
- [ ] 정적 콘텐츠 디렉터리: `assets/contents/{projects,posts,profile}.yaml|md`
- [ ] YAML/Markdown 로더 유틸: `lib/services/content_loader.dart`
- [ ] 샘플 데이터 1~2건 추가 및 바인딩

## 4. 핵심 화면
- [ ] 홈: 핵심 요약, 대표 프로젝트 카드(3)
- [ ] 프로젝트 목록: 필터(스택/도메인), 정렬
- [ ] 프로젝트 상세: 아키텍처/트레이드오프/지표 섹션, 이미지/코드 스니펫 렌더
- [ ] API 쇼케이스: OpenAPI JSON(assets) 로드 + 간단 뷰어(엔드포인트 목록/샘플 요청)
- [ ] 이력서: PDF 링크/다운로드, 요약 카드
- [ ] 연락: 이메일/링크드인/GitHub 버튼

## 5. 블로그(선택)
- [ ] 목록/상세(Markdown 렌더), 태그 필터

## 6. 품질/운영
- [ ] 위젯/단위 테스트: 모델 파싱, 로더, 주요 위젯
- [ ] 접근성 점검: 포커스 트랩, 대비, 스크린리더 라벨
- [ ] SEO: `web/index.html` 메타/OG, 사이트맵 생성 스크립트
- [ ] 성능: 이미지 최적화, 지연 로딩, Lighthouse 90+

## 7. CI/CD & 배포(GitHub Pages)
- [ ] GitHub Actions: analyze → test → build-web → Pages 배포
- [ ] 빌드: `flutter build web --base-href /<REPO_NAME>/`
- [ ] SPA 라우팅: `build/web/index.html`을 `build/web/404.html`로 복사하여 리라이트 처리
- [ ] Pages 설정: 브랜치/폴더(`gh-pages` 또는 GitHub Pages Action 사용) 구성
- [ ] 커스텀 도메인/HTTPS(선택)
- [ ] 버전 태깅/릴리스 노트(선택)

## 8. 콘텐츠 마이그레이션
- [ ] 실제 프로젝트 3~5건 케이스 스터디 작성(MD)
- [ ] 표/다이어그램 이미지 반영, 링크 정리(Repo, Demo)

## 실행/개발 명령 예시
- 개발: `flutter run -d chrome`
- 테스트: `flutter test` (커버리지: `flutter test --coverage`)
- 분석/포맷: `flutter analyze`, `dart format .`
- 빌드(로컬 미리보기): `flutter build web --base-href /<REPO_NAME>/`
