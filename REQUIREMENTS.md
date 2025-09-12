# 백엔드 개발자 포트폴리오: 요건 정의

## 목적과 대상
- 목적: 백엔드 역량(설계, 성능 개선, 운영)을 사례 중심으로 명확히 전달하고 구직/클라이언트 컨버전을 유도.
- 대상: 테크리크루터, 백엔드 리드/아키텍트, 잠재 고객.

## 범위
- 필수: 소개, 보유 기술, 프로젝트/사례 연구, API 쇼케이스, 이력서/다운로드, 연락, SEO/성능, 반응형, 다크모드, 다국어(KO/EN).
- 선택: 기술 블로그, PWA, 분석(Analytics), OpenAPI 뷰어.

## 콘텐츠 구조
- 홈: 핵심 가치/임팩트, 대표 성과 3건, CTA.
- 프로젝트: 목록 + 필터(도메인/스택), 상세(배경→아키텍처→트레이드오프→지표→회고). 다이어그램 이미지/코드 스니펫 지원.
- API 쇼케이스: 대표 API의 OpenAPI 사양(정적 파일)과 예시 요청/응답.
- 블로그(선택): 기술 글 목록/상세(Markdown).
- 이력서: PDF 링크 + 요약.
- 연락: 이메일/링크드인/GitHub.
 - 글로벌: 언어 전환(KO/EN) 토글, 언어별 콘텐츠 제공.

## 비기능 요구사항
- 성능: Lighthouse ≥ 90(웹), 이미지 최적화/지연 로딩.
- 접근성: 키보드 탐색, 대비, ARIA 라벨.
- 국제화: KO/EN 지원, 브라우저 언어 감지 + 수동 전환.
- 품질: 테스트(단위/위젯), 포맷/린트 통과, 타입 안전.
- 운영: 무중단 배포, 롤백 용이, 에러 로깅.

## 기술 스택(제안)
- 프런트: Flutter Web(본 레포), 라우팅(go_router), 상태(Provider/Riverpod 중 택1, Riverpod 권장), Markdown 렌더.
- 국제화: flutter_localizations + gen_l10n(intl, ARB 기반).
- 콘텐츠: assets/contents 내 Markdown/YAML 정적 관리.
- 다이어그램: 이미지(assets/images)로 임베드.
- CI/CD/배포: GitHub Actions(분석/테스트/웹 빌드) → GitHub Pages 배포(단일 페이지 리라이트, base-href 설정).

## 데이터/콘텐츠 모델(요지)
- Project: id, title, period, stack[], role, metrics{}, summary, body(MD), links{repo,demo}.
- Post(선택): id, title, date, tags[], body(MD).
- Profile: name, title, socials{}, skills{lang,infra,tools}.

## 성공 지표
- 전환: 이력서 클릭률, 연락 버튼 클릭률.
- 참여: 프로젝트 상세 체류시간, 스크롤 완료율.
- 운영: 배포 빈도, 버그 회귀율.
