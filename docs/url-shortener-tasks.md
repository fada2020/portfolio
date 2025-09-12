# Next.js URL Shortener — Tasks (KO)

## 0. 초기화
- [ ] `npx create-next-app@latest url-shortener --ts --eslint --app --src --no-tailwind`
- [ ] GitHub repo 생성 및 푸시

## 1. 기본 페이지/레이아웃
- [ ] 홈에 입력 폼(원본 URL) + 결과 카드
- [ ] 라우팅: `/[code]` 리다이렉트 페이지(placeholder)

## 2. Prisma + SQLite 설정
- [ ] `npm i prisma @prisma/client` → `npx prisma init`
- [ ] schema.prisma: `Link(id, code, url, clicks, createdAt)`
- [ ] `npx prisma migrate dev --name init`

## 3. API Routes
- [ ] `POST /api/shorten`: zod 검증, nanoid 생성, DB 저장, JSON 반환
- [ ] `GET /api/stats`: 최근 50개 반환

## 4. 리다이렉트
- [ ] `app/[code]/route.ts`: 코드 조회 → 302 redirect + clicks++
- [ ] 예약어/미존재 코드 처리(404/홈 안내)

## 5. UI 연결
- [ ] 폼 제출 → `/api/shorten` 호출 → 결과 표시/복사 버튼
- [ ] 최근 링크 테이블(서버 컴포넌트)

## 6. 품질/운영
- [ ] 입력 URL 검증(정규식/zod)
- [ ] rate limit(선택): 미들웨어+IP당 쿼터
- [ ] 기본 테스트(e2e는 선택)

## 7. 배포
- [ ] Vercel 연결, ENV(PRISMA_*, DATABASE_URL) 설정
- [ ] README 사용법/제약사항 정리
