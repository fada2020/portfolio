# URL 단축기 (Next.js)

## 개요
- Next.js(App Router) + JavaScript + Prisma + SQLite 기반의 간단한 URL 단축기.
- API Route에서 단축 코드를 발급하고, 동적 라우트 `/:code`에서 원본 URL로 302 리다이렉트.
- 최근 생성 링크와 클릭 수를 보여주는 대시보드 제공.

## 아키텍처
- 라우트 핸들러: `POST /api/shorten`(생성), `GET /api/stats`(목록).
- 리다이렉트: `app/[code]/route.ts`에서 코드 조회 후 302 리다이렉트.
- DB: Prisma + SQLite 스키마 `Link { id, code, url, clicks, createdAt }`.
- 검증: zod + 서버 측 유효성 검사; 미들웨어로 간단한 rate limiting(선택).
- 배포: Vercel(Prisma Data Proxy 또는 파일 기반 SQLite).

## 비고
- nanoid로 충돌 방지; 예약어 차단.
- 필요 시 링크 만료/삭제, UTM/리퍼러 트래킹 확장.

## 결과
- Vercel 리다이렉트(Edge 캐시 히트)에서 100ms 미만 응답.
- 인터뷰/학습용으로 적합한 간결한 코드베이스.
