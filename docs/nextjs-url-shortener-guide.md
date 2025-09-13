# Next.js URL Shortener — Step‑by‑Step Guide

## 0) Create project
- Init: `npx create-next-app@latest url-shortener --ts --eslint --app --src --no-tailwind`
- Dev: `cd url-shortener && npm run dev`

## 1) Install deps
- `npm i prisma @prisma/client zod nanoid`
- `npx prisma init`

## 2) Prisma schema (prisma/schema.prisma)
```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}

model Link {
  id        Int      @id @default(autoincrement())
  code      String   @unique
  url       String
  clicks    Int      @default(0)
  createdAt DateTime @default(now())
}
```
- .env: `DATABASE_URL="file:./dev.db"`
- Migrate: `npx prisma migrate dev --name init`

## 3) Prisma client (src/lib/db.ts)
```ts
import { PrismaClient } from '@prisma/client';
export const prisma = (globalThis as any).prisma || new PrismaClient();
if (process.env.NODE_ENV !== 'production') (globalThis as any).prisma = prisma;
```

## 4) API routes
- Shorten (src/app/api/shorten/route.ts)
```ts
import { NextResponse } from 'next/server';
import { z } from 'zod';
import { nanoid } from 'nanoid';
import { prisma } from '@/lib/db';

const bodySchema = z.object({ url: z.string().url() });

export async function POST(req: Request) {
  const json = await req.json();
  const parse = bodySchema.safeParse(json);
  if (!parse.success) return NextResponse.json({ error: 'Invalid URL' }, { status: 400 });

  const code = nanoid(8);
  const link = await prisma.link.create({ data: { code, url: parse.data.url } });
  return NextResponse.json({ code: link.code, url: link.url }, { status: 201 });
}
```
- Stats (src/app/api/stats/route.ts)
```ts
import { NextResponse } from 'next/server';
import { prisma } from '@/lib/db';

export async function GET() {
  const links = await prisma.link.findMany({ orderBy: { createdAt: 'desc' }, take: 50 });
  return NextResponse.json(links);
}
```

## 5) Redirect handler (src/app/[code]/route.ts)
```ts
import { prisma } from '@/lib/db';

export async function GET(_: Request, { params }: { params: { code: string } }) {
  const link = await prisma.link.findUnique({ where: { code: params.code } });
  if (!link) return new Response('Not found', { status: 404 });
  await prisma.link.update({ where: { id: link.id }, data: { clicks: { increment: 1 } } });
  return Response.redirect(link.url, 302);
}
```

## 6) UI (src/app/page.ts)
```tsx
'use client';
import { useState, useEffect } from 'react';

export default function Page() {
  const [url, setUrl] = useState('');
  const [code, setCode] = useState<string | null>(null);
  const [stats, setStats] = useState<any[]>([]);

  async function onShorten(e: React.FormEvent) {
    e.preventDefault();
    const res = await fetch('/api/shorten', { method: 'POST', body: JSON.stringify({ url }), headers: { 'content-type': 'application/json' } });
    const data = await res.json();
    if (res.ok) setCode(data.code);
  }

  useEffect(() => { fetch('/api/stats').then(r => r.json()).then(setStats); }, [code]);

  return (
    <main style={{ maxWidth: 720, margin: '40px auto', padding: 16 }}>
      <h1>URL Shortener</h1>
      <form onSubmit={onShorten} style={{ display: 'flex', gap: 8 }}>
        <input value={url} onChange={e => setUrl(e.target.value)} placeholder="https://example.com" style={{ flex: 1, padding: 8 }} />
        <button>Shorten</button>
      </form>
      {code && (
        <p style={{ marginTop: 12 }}>Short code: <code>{code}</code> → <a href={`/${code}`}>{location.origin}/{code}</a></p>
      )}
      <h2 style={{ marginTop: 24 }}>Recent</h2>
      <table width="100%" cellPadding={6} style={{ borderCollapse: 'collapse' }}>
        <thead><tr><th>Code</th><th>URL</th><th>Clicks</th><th>Created</th></tr></thead>
        <tbody>
          {stats.map((l) => (
            <tr key={l.id}>
              <td><code>{l.code}</code></td>
              <td><a href={l.url}>{l.url}</a></td>
              <td>{l.clicks}</td>
              <td>{new Date(l.createdAt).toLocaleString()}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </main>
  );
}
```

## 7) Deploy (Vercel)
- `vercel` → 프로젝트 연결
- ENV: `DATABASE_URL`(SQLite: file:./dev.db 또는 서비스 연결)
- `vercel --prod`

## 8) Connect to portfolio
- 포트폴리오 레포의 `assets/contents/{en,ko}/projects.yaml`에 repo/demo URL 반영
- 케이스 본문(`assets/contents/{en,ko}/projects/url-shortener.md`)에 설계/트레이드오프/지표 갱신
