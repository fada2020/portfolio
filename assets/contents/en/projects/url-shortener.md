# URL Shortener (Next.js)

## Overview
- Tiny URL shortener with Next.js App Router, TypeScript, Prisma, SQLite.
- API Routes issue short codes; dynamic route `/:code` redirects to the original URL.
- Minimal dashboard shows recent links and click counts.

## Architecture
- Route handlers: `POST /api/shorten` (create), `GET /api/stats` (list).
- Redirect: `app/[code]/route.ts` finds by code and 302 redirects.
- DB: Prisma + SQLite with `Link { id, code, url, clicks, createdAt }`.
- Validation: zod + server-side checks; rate limiting via middleware (optional).
- Deploy: Vercel with Prisma Data Proxy or file-based SQLite.

## Notes
- Consider slug collision avoidance with nanoid; reserve words blocked.
- Add TTL/expiry for links if needed; track UTM and referrer for insights.

## Results
- End-to-end latency < 100ms on Vercel (Edge cache hit) for redirects.
- Simple codebase suitable for interview demos and learning.
