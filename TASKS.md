# 백엔드 포트폴리오 개발 태스크 플랜

상태: [ ] TODO  [~] 진행중  [x] 완료

## 0. 환경 준비
- [x] Flutter 3.x 설치 및 의존성: `flutter --version`, `flutter pub get`
- [~] 분석/포맷: `flutter analyze` 경고 정리(남은 스타일 경고 처리)

## 1. 정보 구조(IA)와 라우팅
- [x] 라우팅 스켈레톤(go_router): `/`, `/projects`, `/projects/:id`, `/api`, `/blog`, `/resume`, `/contact`
- [x] 기본 테마/레이아웃(AppBar/다크모드/반응형 레이아웃)
- [ ] 404 전용 화면(친절한 안내/빠른 이동 링크)

## 2. 국제화(i18n)
- [x] 의존성/설정: `flutter_localizations` 활성화, `l10n.yaml`, ARB(ko/en)
- [x] `MaterialApp`에 delegates/supportedLocales 적용 + 브라우저/저장 언어 반영
- [x] 언어 전환 토글(UI) + LocalStorage 저장
- [x] URL 쿼리(`?lang=ko|en`) 파싱 및 라우팅 연동
- [x] 콘텐츠 다국어: `assets/contents/{ko,en}/...` 분리
- [ ] i18n 커버리지 점검: 하드코딩 문자열 일괄 추출(Home/Projects/Blog/API/Errors)

## 3. 콘텐츠 스키마와 로더
- [x] 모델 정의: `lib/models/{project,post,profile}.dart`
- [x] 정적 콘텐츠 디렉터리: `assets/contents/{projects,posts,profile}.yaml|md`
- [x] YAML/Markdown 로더 유틸: `lib/services/content_loader.dart`
- [x] 샘플/데모 데이터 바인딩(ko/en)
- [ ] 실제 콘텐츠 보강: 프로젝트 본문 2건(OpenAPI, Content Pipeline) 작성(ko/en)
- [ ] 이력서 PDF 실링크 교체(ko/en)

## 4. 핵심 화면
- [x] 홈: 히어로(프로필 요약) + 대표 프로젝트/최근 글 프리뷰
- [x] 프로젝트 목록: 필터(스택/도메인), 정렬
- [x] 프로젝트 상세: 메트릭/링크/Markdown 본문
- [x] API 쇼케이스: OpenAPI JSON 로드/검색/태그 그룹화/cURL 생성/토큰 옵션
- [x] 이력서: PDF 링크/요약/스킬
- [x] 연락: 이메일/LinkedIn/GitHub 버튼
- [ ] 모바일 내비게이션/헤더 최적화(공간 절약형 메뉴)

## 5. 블로그(선택)
- [x] 목록/상세(Markdown), 태그/검색
- [ ] 포스트 1~2건 추가 및 번역(ko/en)

## 6. 품질/운영
- [x] 위젯/단위 테스트: 로더/필터/cURL/페이지 테스트
- [x] SEO: `web/index.html` 메타/OG, 사이트맵/robots 스크립트
- [~] 접근성(A11y): 버튼 레이블/툴팁/포커스, 대비 점검(추가 작업 필요)
- [ ] 테스트 보강: Home/API 위젯 테스트, 로케일 저장/전환 테스트, 라우터 404 테스트
- [ ] 성능: 이미지/아이콘 최적화, 리스트 스켈레톤/지연 로딩 점검, Lighthouse 90+
- [ ] 경고 제거: analyzer 남은 정렬(sort_constructors_first) 정리

## 7. CI/CD & 배포(GitHub Pages)
- [x] GitHub Actions: analyze → test → build-web → Pages 배포
- [x] 빌드: base-href 자동 계산
- [x] SPA 라우팅: index.html → 404.html 복사
- [ ] CI 최적화: pub 캐시, 테스트 커버리지 업로드(옵션)
- [ ] 커스텀 도메인/HTTPS(옵션)
- [ ] 릴리스 태깅/노트(옵션)

## 8. 콘텐츠 마이그레이션
- [ ] 실제 프로젝트 3~5건 케이스 스터디 작성(MD)
- [ ] 표/다이어그램 이미지 반영, 링크 정리(Repo, Demo)

## 9. SEO/웹 앱 고도화(추가)
- [ ] canonical/hreflang, JSON-LD(Organization/WebSite) 추가
- [ ] PWA/Manifest 보강(name/short_name, 아이콘 세트, offline)
- [ ] OG 이미지 개선(해상도/언어별)

## 10. 접근성/UX(추가)
- [ ] 키보드 내비게이션, 포커스 인디케이터, 스크린리더 라벨 검토
- [ ] 색상 대비/톤 정리(브랜드 컬러/타이포)
- [ ] 접근성 문서/체크리스트 추가

## 11. 문서화(추가)
- [ ] README에 실행/빌드/배포/구조 설명 보강(스크린샷 포함)
- [ ] CONTRIBUTING(옵션), 코드 스타일/브랜치 전략 요약

## 실행/개발 명령 예시
- 개발: `flutter run -d chrome`
- 테스트: `flutter test` (커버리지: `flutter test --coverage`)
- 분석/포맷: `flutter analyze`, `dart format .`
- 빌드(로컬 미리보기): `flutter build web --base-href /<REPO_NAME>/`
