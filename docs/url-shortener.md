# Next.js URL Shortener — Requirements (KO)

## 목표
- Next.js(App Router) + TypeScript로 간단한 URL 단축기 구현
- 짧은 코드 생성/리다이렉트/간단 통계 제공, Vercel 배포

## 핵심 기능
- POST /api/shorten: 유효한 URL 검증 후 code 발급(nanoid)
- GET /:code: DB 조회 → 302 redirect, clicks 증가
- 대시보드: 최근 생성 링크, 클릭 수 목록(SSR/RSC)

## 기술 스택
- Next.js, React, TypeScript, Prisma, SQLite, zod, Vercel

## 데이터 모델
- Link(id, code, url, clicks, createdAt)

## 비기능 요구
- ISR/캐싱, 입력 검증, 간단한 rate limiting(선택), 로그(Errors)

## 완료 기준
- Demo 배포 URL에서 shorten/redirect 동작, README 사용법, 기본 테스트 통과
