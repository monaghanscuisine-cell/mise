# CLAUDE.md — Mise Build Instructions

You are working inside the existing Mise Next.js project.

## Current Project Status
- The app already runs locally.
- GitHub is connected.
- Supabase credentials are already in `.env.local`.
- Do not restart or re-scaffold the project.
- Do not overwrite `.env.local`.
- Do not delete working auth or app shell files.
- Do not modify `package.json` unless absolutely required.

## Workflow Rules
Work one issue at a time from `ISSUE_LIBRARY.md`.

Before starting:
1. Inspect the current repository.
2. Determine whether earlier issues are already complete.
3. Start with the first incomplete issue.

For each issue:
1. Read the full issue requirements.
2. Make the smallest safe changes.
3. Preserve localhost stability.
4. Run checks where possible:
   - `npm run type-check`
   - `npm run lint`
   - `npm run dev`
5. Stop after one issue.
6. Summarize:
   - issue completed
   - files changed
   - tests run
   - manual steps needed

## Safety Rules
- Never overwrite `.env.local`.
- Never commit secrets.
- Never edit `.next`.
- Never make giant refactors.
- Never jump ahead to later issues.
- Keep changes small, testable, and easy to revert.

## First Task
Read `ISSUE_LIBRARY.md`, inspect the repo, and begin with the first incomplete issue, likely ISSUE-006 or ISSUE-007.