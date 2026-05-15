# Supabase Migrations

## Apply via Dashboard
1. Supabase Dashboard -> SQL Editor -> + New query
2. Paste contents of migration file
3. Click Run

## Apply via CLI
```
supabase login
supabase link
supabase db push
supabase gen types typescript --linked > lib/database.types.ts
```

## Files
| File | Issue | Description |
|------|-------|-------------|
| 001_initial_schema.sql | 5 | All 8 tables, enums, RLS, indexes |
| 002_buy_list_function.sql | 19 | get_buy_list() |
| 003_prep_list_function.sql | 21 | get_prep_list() |