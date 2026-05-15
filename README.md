# Mise

Production planning for catering and events.

## Setup

```bash
npm install
copy .env.example .env.local
# Fill in NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY
npm run dev
```

Open http://localhost:3000

## Scripts

| Command              | Description       |
|----------------------|-------------------|
| `npm run dev`        | Dev server        |
| `npm run build`      | Production build  |
| `npm run lint`       | ESLint            |
| `npm run type-check` | TypeScript check  |
| `npm test`           | Jest tests        |

## Issue progress

- [x] ISSUE-001 Project setup
- [x] ISSUE-002 Connect Supabase
- [x] ISSUE-003 Auth
- [x] ISSUE-004 App shell
- [x] ISSUE-005 Database schema
- [ ] ISSUE-006 TypeScript types
- [ ] ISSUE-007 onwards...