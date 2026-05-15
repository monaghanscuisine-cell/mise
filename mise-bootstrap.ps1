# mise-bootstrap.ps1
# Creates the full Mise Issues 1-5 file structure at C:\Users\17659\mise
# Run from any directory: powershell -ExecutionPolicy Bypass -File mise-bootstrap.ps1

$root = "C:\Users\17659\mise"

# ── Helper ────────────────────────────────────────────────────────────────────
function Write-File {
    param([string]$Path, [string]$Content)
    $dir = Split-Path $Path -Parent
    if ($dir -and !(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.Encoding]::UTF8)
    Write-Host "  wrote $($Path.Replace($root, ''))"
}

Write-Host ""
Write-Host "Mise bootstrap — Issues 1-5" -ForegroundColor Cyan
Write-Host "Target: $root" -ForegroundColor Cyan
Write-Host ""

# ── Directories ───────────────────────────────────────────────────────────────
$dirs = @(
    "$root\app\(auth)\login",
    "$root\app\(auth)\signup",
    "$root\app\(app)\recipes\new",
    "$root\app\(app)\events\new",
    "$root\app\(app)\ingredients",
    "$root\components\nav",
    "$root\components\ui",
    "$root\lib\supabase",
    "$root\supabase\migrations"
)
foreach ($d in $dirs) {
    New-Item -ItemType Directory -Path $d -Force | Out-Null
}
Write-Host "Directories created." -ForegroundColor Green

# ── package.json ──────────────────────────────────────────────────────────────
Write-File "$root\package.json" @'
{
  "name": "mise",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit",
    "test": "jest"
  },
  "dependencies": {
    "next": "15.3.2",
    "react": "19.1.0",
    "react-dom": "19.1.0",
    "@supabase/supabase-js": "^2.49.4",
    "@supabase/ssr": "^0.6.1"
  },
  "devDependencies": {
    "typescript": "^5.8.3",
    "@types/node": "^22.15.17",
    "@types/react": "^19.1.4",
    "@types/react-dom": "^19.1.4",
    "tailwindcss": "^3.4.17",
    "postcss": "^8.5.3",
    "autoprefixer": "^10.4.21",
    "eslint": "^9.26.0",
    "eslint-config-next": "15.3.2",
    "jest": "^29.7.0",
    "ts-jest": "^29.3.2",
    "@types/jest": "^29.5.14"
  }
}
'@

# ── tsconfig.json ─────────────────────────────────────────────────────────────
Write-File "$root\tsconfig.json" @'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
'@

# ── tailwind.config.ts ────────────────────────────────────────────────────────
Write-File "$root\tailwind.config.ts" @'
import type { Config } from "tailwindcss"

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans:  ["var(--font-sans)", "system-ui", "sans-serif"],
        serif: ["Georgia", "Cambria", "Times New Roman", "serif"],
      },
      colors: {
        mise: {
          ink:   "#1a1a18",
          paper: "#faf9f6",
          stone: "#6b6b63",
          rule:  "#e2e0da",
          sage:  "#4a5e4a",
          amber: "#c47c2b",
          rust:  "#b34b3a",
        },
      },
    },
  },
  plugins: [],
}

export default config
'@

# ── postcss.config.mjs ────────────────────────────────────────────────────────
Write-File "$root\postcss.config.mjs" @'
/** @type {import("postcss-load-config").Config} */
const config = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
export default config
'@

# ── next.config.ts ────────────────────────────────────────────────────────────
Write-File "$root\next.config.ts" @'
import type { NextConfig } from "next"
const nextConfig: NextConfig = {}
export default nextConfig
'@

# ── eslint.config.mjs ─────────────────────────────────────────────────────────
Write-File "$root\eslint.config.mjs" @'
import { dirname } from "path"
import { fileURLToPath } from "url"
import { FlatCompat } from "@eslint/eslintrc"

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)
const compat = new FlatCompat({ baseDirectory: __dirname })

const eslintConfig = [
  ...compat.extends("next/core-web-vitals", "next/typescript"),
]

export default eslintConfig
'@

# ── jest.config.ts ────────────────────────────────────────────────────────────
Write-File "$root\jest.config.ts" @'
import type { Config } from "jest"

const config: Config = {
  preset: "ts-jest",
  testEnvironment: "node",
  moduleNameMapper: { "^@/(.*)$": "<rootDir>/$1" },
  testMatch: ["**/*.test.ts", "**/*.test.tsx"],
  transform: {
    "^.+\\.tsx?$": ["ts-jest", { tsconfig: { strict: true } }],
  },
}

export default config
'@

# ── .gitignore ────────────────────────────────────────────────────────────────
Write-File "$root\.gitignore" @'
node_modules/
.pnp
.pnp.js
.next/
out/
dist/
build/
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
supabase/.branches/
supabase/.temp/
# Uncomment after Issue 6 type generation:
# lib/database.types.ts
coverage/
.DS_Store
.vscode/
.idea/
*.swp
*.swo
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.vercel
'@

# ── .env.example ──────────────────────────────────────────────────────────────
Write-File "$root\.env.example" @'
# Supabase — Project Settings -> API
NEXT_PUBLIC_SUPABASE_URL=https://your-project-ref.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
'@

# ── README.md ─────────────────────────────────────────────────────────────────
Write-File "$root\README.md" @'
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
'@

# ── middleware.ts ─────────────────────────────────────────────────────────────
Write-File "$root\middleware.ts" @'
import { createServerClient } from "@supabase/ssr"
import { NextResponse, type NextRequest } from "next/server"

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return request.cookies.getAll() },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  const { data: { user } } = await supabase.auth.getUser()
  const { pathname } = request.nextUrl
  const isAuthRoute = pathname === "/login" || pathname === "/signup"

  if (!user && !isAuthRoute) {
    const url = request.nextUrl.clone()
    url.pathname = "/login"
    return NextResponse.redirect(url)
  }
  if (user && isAuthRoute) {
    const url = request.nextUrl.clone()
    url.pathname = "/"
    return NextResponse.redirect(url)
  }

  return supabaseResponse
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon\\.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico|woff|woff2)$).*)",
  ],
}
'@

# ── app/globals.css ───────────────────────────────────────────────────────────
Write-File "$root\app\globals.css" @'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --color-ink:   #1a1a18;
  --color-paper: #faf9f6;
  --color-stone: #6b6b63;
  --color-rule:  #e2e0da;
  --color-sage:  #4a5e4a;
  --color-amber: #c47c2b;
  --color-rust:  #b34b3a;
}

html {
  background-color: var(--color-paper);
  color: var(--color-ink);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

@media print {
  @page { size: Letter portrait; margin: 0.75in; }
  html, body {
    font-family: Georgia, Cambria, "Times New Roman", serif;
    font-size: 11pt;
    line-height: 1.5;
    color: black;
    background: white;
  }
  * {
    box-shadow: none !important;
    text-shadow: none !important;
    background-color: transparent !important;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }
  img { page-break-inside: avoid; max-width: 100%; }
  a[href]::after { content: none; }
}
'@

# ── app/layout.tsx ────────────────────────────────────────────────────────────
Write-File "$root\app\layout.tsx" @'
import type { Metadata } from "next"
import "./globals.css"

export const metadata: Metadata = {
  title: { default: "Mise", template: "%s — Mise" },
  description: "Production planning for catering and events.",
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
'@

# ── app/(auth)/layout.tsx ─────────────────────────────────────────────────────
Write-File "$root\app\(auth)\layout.tsx" @'
export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-mise-paper flex flex-col items-center justify-center px-4">
      <p className="font-serif text-2xl text-mise-ink tracking-tight mb-8">Mise</p>
      <div className="w-full max-w-sm bg-white border border-mise-rule rounded-lg p-8 shadow-sm">
        {children}
      </div>
    </div>
  )
}
'@

# ── app/(auth)/login/page.tsx ─────────────────────────────────────────────────
Write-File "$root\app\(auth)\login\page.tsx" @'
"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import Link from "next/link"
import { createClient } from "@/lib/supabase/client"

export default function LoginPage() {
  const router = useRouter()
  const [email,    setEmail]    = useState("")
  const [password, setPassword] = useState("")
  const [error,    setError]    = useState("")
  const [loading,  setLoading]  = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError("")
    setLoading(true)
    const supabase = createClient()
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) {
      setError(
        error.message.includes("Invalid login credentials") ||
        error.message.includes("invalid_credentials")
          ? "Incorrect email or password."
          : "Something went wrong. Please try again."
      )
      setLoading(false)
      return
    }
    router.refresh()
    router.push("/")
  }

  return (
    <>
      <h1 className="font-serif text-xl text-mise-ink mb-6">Log in</h1>
      <form onSubmit={handleSubmit} noValidate className="flex flex-col gap-4">
        <div className="flex flex-col gap-1">
          <label htmlFor="email" className="text-xs text-mise-stone uppercase tracking-wide">Email</label>
          <input id="email" type="email" autoComplete="email" required value={email}
            onChange={e => setEmail(e.target.value)} placeholder="you@example.com"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        <div className="flex flex-col gap-1">
          <label htmlFor="password" className="text-xs text-mise-stone uppercase tracking-wide">Password</label>
          <input id="password" type="password" autoComplete="current-password" required value={password}
            onChange={e => setPassword(e.target.value)} placeholder="••••••••"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        {error && <p className="text-sm text-mise-rust" role="alert">{error}</p>}
        <button type="submit" disabled={loading}
          className="w-full mt-2 bg-mise-ink text-mise-paper text-sm py-2.5 rounded hover:bg-mise-stone transition-colors disabled:opacity-50">
          {loading ? "Logging in…" : "Log in"}
        </button>
      </form>
      <p className="mt-6 text-center text-xs text-mise-stone">
        No account?{" "}
        <Link href="/signup" className="text-mise-ink underline underline-offset-2">Sign up</Link>
      </p>
    </>
  )
}
'@

# ── app/(auth)/signup/page.tsx ────────────────────────────────────────────────
Write-File "$root\app\(auth)\signup\page.tsx" @'
"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import Link from "next/link"
import { createClient } from "@/lib/supabase/client"

export default function SignupPage() {
  const router = useRouter()
  const [email,      setEmail]      = useState("")
  const [password,   setPassword]   = useState("")
  const [confirm,    setConfirm]    = useState("")
  const [error,      setError]      = useState("")
  const [loading,    setLoading]    = useState(false)
  const [checkEmail, setCheckEmail] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError("")
    if (password.length < 8) { setError("Password must be at least 8 characters."); return }
    if (password !== confirm) { setError("Passwords do not match."); return }
    setLoading(true)
    const supabase = createClient()
    const { data, error } = await supabase.auth.signUp({ email, password })
    if (error) {
      setError(
        error.message.includes("already registered") || error.message.includes("already exists")
          ? "An account with this email already exists. Try logging in."
          : "Something went wrong. Please try again."
      )
      setLoading(false)
      return
    }
    if (data.user && data.user.identities && data.user.identities.length === 0) {
      setCheckEmail(true)
      setLoading(false)
      return
    }
    router.refresh()
    router.push("/")
  }

  if (checkEmail) {
    return (
      <>
        <h1 className="font-serif text-xl text-mise-ink mb-4">Check your email</h1>
        <p className="text-sm text-mise-stone leading-relaxed">
          We sent a confirmation link to <span className="text-mise-ink font-medium">{email}</span>.
        </p>
        <div className="mt-6 text-center">
          <Link href="/login" className="text-sm text-mise-ink underline underline-offset-2">Back to log in</Link>
        </div>
      </>
    )
  }

  return (
    <>
      <h1 className="font-serif text-xl text-mise-ink mb-6">Create account</h1>
      <form onSubmit={handleSubmit} noValidate className="flex flex-col gap-4">
        <div className="flex flex-col gap-1">
          <label htmlFor="email" className="text-xs text-mise-stone uppercase tracking-wide">Email</label>
          <input id="email" type="email" autoComplete="email" required value={email}
            onChange={e => setEmail(e.target.value)} placeholder="you@example.com"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        <div className="flex flex-col gap-1">
          <label htmlFor="password" className="text-xs text-mise-stone uppercase tracking-wide">Password</label>
          <input id="password" type="password" autoComplete="new-password" required value={password}
            onChange={e => setPassword(e.target.value)} placeholder="At least 8 characters"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        <div className="flex flex-col gap-1">
          <label htmlFor="confirm" className="text-xs text-mise-stone uppercase tracking-wide">Confirm password</label>
          <input id="confirm" type="password" autoComplete="new-password" required value={confirm}
            onChange={e => setConfirm(e.target.value)} placeholder="••••••••"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        {error && <p className="text-sm text-mise-rust" role="alert">{error}</p>}
        <button type="submit" disabled={loading}
          className="w-full mt-2 bg-mise-ink text-mise-paper text-sm py-2.5 rounded hover:bg-mise-stone transition-colors disabled:opacity-50">
          {loading ? "Creating account…" : "Create account"}
        </button>
      </form>
      <p className="mt-6 text-center text-xs text-mise-stone">
        Already have an account?{" "}
        <Link href="/login" className="text-mise-ink underline underline-offset-2">Log in</Link>
      </p>
    </>
  )
}
'@

# ── app/(app)/actions.ts ──────────────────────────────────────────────────────
Write-File "$root\app\(app)\actions.ts" @'
"use server"

import { createClient } from "@/lib/supabase/server"
import { redirect } from "next/navigation"

export async function signOut() {
  const supabase = await createClient()
  await supabase.auth.signOut()
  redirect("/login")
}
'@

# ── app/(app)/layout.tsx ──────────────────────────────────────────────────────
Write-File "$root\app\(app)\layout.tsx" @'
import { redirect } from "next/navigation"
import { createClient } from "@/lib/supabase/server"
import NavBar from "@/components/nav/NavBar"

export default async function AppLayout({ children }: { children: React.ReactNode }) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect("/login")

  return (
    <div className="min-h-screen bg-mise-paper">
      <NavBar email={user.email ?? ""} />
      <main className="max-w-5xl mx-auto px-4 py-8">{children}</main>
    </div>
  )
}
'@

# ── app/(app)/page.tsx ────────────────────────────────────────────────────────
Write-File "$root\app\(app)\page.tsx" @'
import Link from "next/link"

function NavCard({ href, label, count, description, icon }: {
  href: string; label: string; count: number; description: string; icon: string
}) {
  return (
    <Link href={href}
      className="group flex flex-col gap-3 p-6 bg-white border border-mise-rule rounded-lg hover:border-mise-stone hover:shadow-sm transition-all">
      <div className="flex items-start justify-between">
        <span className="text-2xl select-none" aria-hidden>{icon}</span>
        <span className="font-serif text-3xl text-mise-ink leading-none">{count}</span>
      </div>
      <div>
        <p className="font-serif text-lg text-mise-ink group-hover:text-mise-stone transition-colors">{label}</p>
        <p className="text-xs text-mise-stone mt-0.5 leading-relaxed">{description}</p>
      </div>
    </Link>
  )
}

export default function HomePage() {
  return (
    <div className="max-w-2xl">
      <div className="mb-8">
        <h1 className="font-serif text-2xl text-mise-ink tracking-tight">Mise</h1>
        <p className="text-sm text-mise-stone mt-1">Production planning for catering and events.</p>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-6">
        <NavCard href="/recipes" label="Recipes" count={0} description="Your dish library. Scale to any headcount." icon="📖" />
        <NavCard href="/events"  label="Events"  count={0} description="Build menus, assign team, print packets."   icon="📅" />
      </div>
      <Link href="/events/new"
        className="inline-flex items-center gap-2 px-5 py-2.5 bg-mise-ink text-mise-paper text-sm rounded hover:bg-mise-stone transition-colors">
        <span aria-hidden>+</span> New Event
      </Link>
      <p className="text-xs text-mise-stone mt-6 border-t border-mise-rule pt-4">
        Start by adding a recipe or creating an event.
      </p>
    </div>
  )
}
'@

# ── app/(app)/recipes/page.tsx ────────────────────────────────────────────────
Write-File "$root\app\(app)\recipes\page.tsx" @'
import PageHeader from "@/components/ui/PageHeader"
import EmptyState from "@/components/ui/EmptyState"

export const metadata = { title: "Recipes" }

export default function RecipesPage() {
  return (
    <>
      <PageHeader title="Recipes" subtitle="Your dish library"
        action={{ label: "+ New Recipe", href: "/recipes/new" }} />
      <EmptyState icon="📖" heading="No recipes yet"
        message="Add your first recipe to build your library."
        action={{ label: "+ Add Recipe", href: "/recipes/new" }} />
    </>
  )
}
'@

# ── app/(app)/recipes/new/page.tsx ────────────────────────────────────────────
Write-File "$root\app\(app)\recipes\new\page.tsx" @'
import Link from "next/link"
import PageHeader from "@/components/ui/PageHeader"

export const metadata = { title: "New Recipe" }

export default function NewRecipePage() {
  return (
    <>
      <PageHeader title="New Recipe" />
      <div className="max-w-xl bg-white border border-mise-rule rounded-lg p-8">
        <p className="text-sm text-mise-stone mb-4">Recipe builder coming in Issue 8.</p>
        <Link href="/recipes" className="text-xs text-mise-stone underline underline-offset-2">
          ← Back to Recipes
        </Link>
      </div>
    </>
  )
}
'@

# ── app/(app)/events/page.tsx ─────────────────────────────────────────────────
Write-File "$root\app\(app)\events\page.tsx" @'
import PageHeader from "@/components/ui/PageHeader"
import EmptyState from "@/components/ui/EmptyState"

export const metadata = { title: "Events" }

export default function EventsPage() {
  return (
    <>
      <PageHeader title="Events" subtitle="Catering jobs and events"
        action={{ label: "+ New Event", href: "/events/new" }} />
      <EmptyState icon="📅" heading="No events yet"
        message="Create an event to build a menu, assign your team, and generate print-ready packets."
        action={{ label: "+ New Event", href: "/events/new" }} />
    </>
  )
}
'@

# ── app/(app)/events/new/page.tsx ─────────────────────────────────────────────
Write-File "$root\app\(app)\events\new\page.tsx" @'
import Link from "next/link"
import PageHeader from "@/components/ui/PageHeader"

export const metadata = { title: "New Event" }

export default function NewEventPage() {
  return (
    <>
      <PageHeader title="New Event" />
      <div className="max-w-xl bg-white border border-mise-rule rounded-lg p-8">
        <p className="text-sm text-mise-stone mb-4">Event creation form coming in Issue 13.</p>
        <Link href="/events" className="text-xs text-mise-stone underline underline-offset-2">
          ← Back to Events
        </Link>
      </div>
    </>
  )
}
'@

# ── app/(app)/ingredients/page.tsx ───────────────────────────────────────────
Write-File "$root\app\(app)\ingredients\page.tsx" @'
import PageHeader from "@/components/ui/PageHeader"
import EmptyState from "@/components/ui/EmptyState"

export const metadata = { title: "Ingredients" }

export default function IngredientsPage() {
  return (
    <>
      <PageHeader title="Ingredients" subtitle="Shared ingredient library" />
      <EmptyState icon="🧅" heading="No ingredients yet"
        message="Your ingredient library powers autocomplete in the recipe builder and category grouping in the buy list." />
    </>
  )
}
'@

# ── components/nav/NavBar.tsx ─────────────────────────────────────────────────
Write-File "$root\components\nav\NavBar.tsx" @'
"use client"

import Link from "next/link"
import { usePathname } from "next/navigation"
import { signOut } from "@/app/(app)/actions"

const NAV_LINKS = [
  { href: "/",            label: "Home"        },
  { href: "/recipes",     label: "Recipes"     },
  { href: "/events",      label: "Events"      },
  { href: "/ingredients", label: "Ingredients" },
] as const

export default function NavBar({ email }: { email: string }) {
  const pathname = usePathname()
  const isActive = (href: string) => href === "/" ? pathname === "/" : pathname.startsWith(href)

  return (
    <header className="border-b border-mise-rule bg-white print:hidden sticky top-0 z-10">
      <div className="max-w-5xl mx-auto px-4">
        <div className="flex items-center justify-between h-12">
          <Link href="/" className="font-serif text-base text-mise-ink tracking-tight select-none">Mise</Link>

          <nav className="flex items-center gap-1" aria-label="Main navigation">
            {NAV_LINKS.map(({ href, label }) => (
              <Link key={href} href={href}
                className={[
                  "px-3 py-1.5 rounded text-sm transition-colors",
                  isActive(href)
                    ? "bg-mise-ink text-mise-paper"
                    : "text-mise-stone hover:text-mise-ink hover:bg-mise-paper",
                ].join(" ")}>
                {label}
              </Link>
            ))}
          </nav>

          <div className="flex items-center gap-3">
            <span className="text-xs text-mise-stone hidden md:block truncate max-w-[180px]">{email}</span>
            <form action={signOut}>
              <button type="submit" className="text-xs text-mise-stone hover:text-mise-ink transition-colors">
                Log out
              </button>
            </form>
          </div>
        </div>
      </div>
    </header>
  )
}
'@

# ── components/ui/EmptyState.tsx ──────────────────────────────────────────────
Write-File "$root\components\ui\EmptyState.tsx" @'
import Link from "next/link"

interface EmptyStateProps {
  icon?: string
  heading: string
  message?: string
  action?: { label: string; href?: string; onClick?: () => void }
}

export default function EmptyState({ icon, heading, message, action }: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center py-20 px-4 text-center">
      {icon && <span className="text-3xl mb-4 opacity-40 select-none" aria-hidden>{icon}</span>}
      <p className="font-serif text-lg text-mise-ink mb-1">{heading}</p>
      {message && <p className="text-sm text-mise-stone max-w-xs leading-relaxed mb-6">{message}</p>}
      {action && (
        action.href
          ? <Link href={action.href}
              className="inline-flex items-center px-4 py-2 bg-mise-ink text-mise-paper text-sm rounded hover:bg-mise-stone transition-colors">
              {action.label}
            </Link>
          : <button onClick={action.onClick}
              className="inline-flex items-center px-4 py-2 bg-mise-ink text-mise-paper text-sm rounded hover:bg-mise-stone transition-colors">
              {action.label}
            </button>
      )}
    </div>
  )
}
'@

# ── components/ui/PageHeader.tsx ──────────────────────────────────────────────
Write-File "$root\components\ui\PageHeader.tsx" @'
import Link from "next/link"

interface PageHeaderProps {
  title: string
  subtitle?: string
  action?: { label: string; href?: string; onClick?: () => void }
}

export default function PageHeader({ title, subtitle, action }: PageHeaderProps) {
  return (
    <div className="flex items-start justify-between mb-8">
      <div>
        <h1 className="font-serif text-2xl text-mise-ink tracking-tight">{title}</h1>
        {subtitle && <p className="text-sm text-mise-stone mt-0.5">{subtitle}</p>}
      </div>
      {action && (
        action.href
          ? <Link href={action.href}
              className="inline-flex items-center px-4 py-2 bg-mise-ink text-mise-paper text-sm rounded hover:bg-mise-stone transition-colors shrink-0 ml-4">
              {action.label}
            </Link>
          : <button onClick={action.onClick}
              className="inline-flex items-center px-4 py-2 bg-mise-ink text-mise-paper text-sm rounded hover:bg-mise-stone transition-colors shrink-0 ml-4">
              {action.label}
            </button>
      )}
    </div>
  )
}
'@

# ── lib/supabase/client.ts ────────────────────────────────────────────────────
Write-File "$root\lib\supabase\client.ts" @'
import { createBrowserClient } from "@supabase/ssr"
import type { Database } from "@/lib/database.types"

export function createClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
'@

# ── lib/supabase/server.ts ────────────────────────────────────────────────────
Write-File "$root\lib\supabase\server.ts" @'
import { createServerClient } from "@supabase/ssr"
import { cookies } from "next/headers"
import type { Database } from "@/lib/database.types"

export async function createClient() {
  const cookieStore = await cookies()
  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return cookieStore.getAll() },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch { /* Server Component — middleware handles session refresh */ }
        },
      },
    }
  )
}
'@

# ── lib/database.types.ts ─────────────────────────────────────────────────────
Write-File "$root\lib\database.types.ts" @'
// Hand-written stub — matches 001_initial_schema.sql
// Replace after Issue 6: supabase gen types typescript --linked > lib/database.types.ts

export type IngredientCategory =
  | "produce" | "protein" | "dairy" | "dry_goods"
  | "canned_jarred" | "frozen" | "bread_bakery"
  | "beverage" | "specialty" | "other"

export type EventStatus = "draft" | "confirmed" | "completed" | "cancelled"
export type AssignmentRole = "prep" | "cooking" | "plating" | "packing" | "general"

export type Ingredient = {
  id: string; user_id: string; name: string
  category: IngredientCategory; default_unit: string | null
  notes: string | null; created_at: string
}
export type Recipe = {
  id: string; user_id: string; name: string; description: string | null
  base_yield_quantity: number; base_yield_unit: string
  plating_notes: string | null; timing_notes: string | null; team_notes: string | null
  tags: string[]; is_archived: boolean; created_at: string; updated_at: string
}
export type RecipeIngredient = {
  id: string; recipe_id: string; ingredient_id: string
  quantity: number; unit: string; prep_note: string | null; sort_order: number
}
export type PrepStep = {
  id: string; recipe_id: string; step_number: number
  instruction: string; timing_label: string | null; is_critical: boolean
}
export type CookStep = {
  id: string; recipe_id: string; step_number: number
  instruction: string; timing_label: string | null
}
export type Event = {
  id: string; user_id: string; name: string; event_date: string | null
  service_time: string | null; location: string | null; headcount: number
  notes: string | null; status: EventStatus; created_at: string; updated_at: string
}
export type EventRecipe = {
  id: string; event_id: string; recipe_id: string; sort_order: number
  headcount_override: number | null; notes: string | null
}
export type TeamAssignment = {
  id: string; event_recipe_id: string; role: AssignmentRole
  assignee_name: string; notes: string | null
}

export type IngredientInsert    = Omit<Ingredient,     "id" | "created_at">
export type RecipeInsert        = Omit<Recipe,         "id" | "created_at" | "updated_at">
export type EventInsert         = Omit<Event,          "id" | "created_at" | "updated_at">
export type EventRecipeInsert   = Omit<EventRecipe,    "id">
export type TeamAssignmentInsert = Omit<TeamAssignment, "id">

export type Database = {
  public: {
    Tables: {
      ingredients:        { Row: Ingredient;       Insert: IngredientInsert;        Update: Partial<IngredientInsert>        }
      recipes:            { Row: Recipe;           Insert: RecipeInsert;            Update: Partial<RecipeInsert>            }
      recipe_ingredients: { Row: RecipeIngredient; Insert: Omit<RecipeIngredient,"id">; Update: Partial<Omit<RecipeIngredient,"id">> }
      prep_steps:         { Row: PrepStep;         Insert: Omit<PrepStep,"id">;         Update: Partial<Omit<PrepStep,"id">>         }
      cook_steps:         { Row: CookStep;         Insert: Omit<CookStep,"id">;         Update: Partial<Omit<CookStep,"id">>         }
      events:             { Row: Event;            Insert: EventInsert;             Update: Partial<EventInsert>             }
      event_recipes:      { Row: EventRecipe;      Insert: EventRecipeInsert;       Update: Partial<EventRecipeInsert>       }
      team_assignments:   { Row: TeamAssignment;   Insert: TeamAssignmentInsert;    Update: Partial<TeamAssignmentInsert>    }
    }
    Views: Record<string, never>
    Functions: Record<string, never>
    Enums: {
      ingredient_category: IngredientCategory
      event_status: EventStatus
      assignment_role: AssignmentRole
    }
  }
}
'@

# ── supabase/migrations/001_initial_schema.sql ────────────────────────────────
Write-File "$root\supabase\migrations\001_initial_schema.sql" @'
-- Mise Initial Schema
create extension if not exists moddatetime schema extensions;

create type ingredient_category as enum (
  ''produce'',''protein'',''dairy'',''dry_goods'',''canned_jarred'',
  ''frozen'',''bread_bakery'',''beverage'',''specialty'',''other''
);
create type event_status as enum (''draft'',''confirmed'',''completed'',''cancelled'');
create type assignment_role as enum (''prep'',''cooking'',''plating'',''packing'',''general'');

-- ingredients
create table ingredients (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  name         text not null,
  category     ingredient_category not null default ''other'',
  default_unit text,
  notes        text,
  created_at   timestamptz not null default now(),
  constraint ingredients_user_name_unique unique (user_id, name)
);
alter table ingredients enable row level security;
create policy "ingredients: owner select" on ingredients for select using (auth.uid() = user_id);
create policy "ingredients: owner insert" on ingredients for insert with check (auth.uid() = user_id);
create policy "ingredients: owner update" on ingredients for update using (auth.uid() = user_id);
create policy "ingredients: owner delete" on ingredients for delete using (auth.uid() = user_id);
create index ingredients_user_id_idx  on ingredients (user_id);
create index ingredients_name_idx     on ingredients (user_id, lower(name));
create index ingredients_category_idx on ingredients (user_id, category);

-- recipes
create table recipes (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references auth.users (id) on delete cascade,
  name                text not null,
  description         text,
  base_yield_quantity numeric not null default 1 check (base_yield_quantity > 0),
  base_yield_unit     text not null default ''portions'',
  plating_notes       text,
  timing_notes        text,
  team_notes          text,
  tags                text[] not null default ''{}''::text[],
  is_archived         boolean not null default false,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);
create trigger recipes_updated_at before update on recipes
  for each row execute procedure extensions.moddatetime(updated_at);
alter table recipes enable row level security;
create policy "recipes: owner select" on recipes for select using (auth.uid() = user_id);
create policy "recipes: owner insert" on recipes for insert with check (auth.uid() = user_id);
create policy "recipes: owner update" on recipes for update using (auth.uid() = user_id);
create policy "recipes: owner delete" on recipes for delete using (auth.uid() = user_id);
create index recipes_user_id_idx    on recipes (user_id);
create index recipes_updated_at_idx on recipes (user_id, updated_at desc);
create index recipes_archived_idx   on recipes (user_id, is_archived);
create index recipes_tags_idx       on recipes using gin (tags);

-- recipe_ingredients
create table recipe_ingredients (
  id            uuid primary key default gen_random_uuid(),
  recipe_id     uuid not null references recipes (id) on delete cascade,
  ingredient_id uuid not null references ingredients (id) on delete restrict,
  quantity      numeric not null check (quantity > 0),
  unit          text not null,
  prep_note     text,
  sort_order    integer not null default 0
);
alter table recipe_ingredients enable row level security;
create policy "recipe_ingredients: owner select" on recipe_ingredients for select
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "recipe_ingredients: owner insert" on recipe_ingredients for insert
  with check (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "recipe_ingredients: owner update" on recipe_ingredients for update
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "recipe_ingredients: owner delete" on recipe_ingredients for delete
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create index recipe_ingredients_recipe_id_idx     on recipe_ingredients (recipe_id);
create index recipe_ingredients_ingredient_id_idx on recipe_ingredients (ingredient_id);
create index recipe_ingredients_sort_idx          on recipe_ingredients (recipe_id, sort_order);

-- prep_steps
create table prep_steps (
  id           uuid primary key default gen_random_uuid(),
  recipe_id    uuid not null references recipes (id) on delete cascade,
  step_number  integer not null check (step_number > 0),
  instruction  text not null,
  timing_label text,
  is_critical  boolean not null default false,
  constraint prep_steps_recipe_step_unique unique (recipe_id, step_number)
);
alter table prep_steps enable row level security;
create policy "prep_steps: owner select" on prep_steps for select
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "prep_steps: owner insert" on prep_steps for insert
  with check (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "prep_steps: owner update" on prep_steps for update
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "prep_steps: owner delete" on prep_steps for delete
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create index prep_steps_recipe_id_idx  on prep_steps (recipe_id);
create index prep_steps_step_order_idx on prep_steps (recipe_id, step_number);

-- cook_steps
create table cook_steps (
  id           uuid primary key default gen_random_uuid(),
  recipe_id    uuid not null references recipes (id) on delete cascade,
  step_number  integer not null check (step_number > 0),
  instruction  text not null,
  timing_label text,
  constraint cook_steps_recipe_step_unique unique (recipe_id, step_number)
);
alter table cook_steps enable row level security;
create policy "cook_steps: owner select" on cook_steps for select
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "cook_steps: owner insert" on cook_steps for insert
  with check (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "cook_steps: owner update" on cook_steps for update
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "cook_steps: owner delete" on cook_steps for delete
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create index cook_steps_recipe_id_idx  on cook_steps (recipe_id);
create index cook_steps_step_order_idx on cook_steps (recipe_id, step_number);

-- events
create table events (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  name         text not null,
  event_date   date,
  service_time time,
  location     text,
  headcount    integer not null check (headcount > 0),
  notes        text,
  status       event_status not null default ''draft'',
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create trigger events_updated_at before update on events
  for each row execute procedure extensions.moddatetime(updated_at);
alter table events enable row level security;
create policy "events: owner select" on events for select using (auth.uid() = user_id);
create policy "events: owner insert" on events for insert with check (auth.uid() = user_id);
create policy "events: owner update" on events for update using (auth.uid() = user_id);
create policy "events: owner delete" on events for delete using (auth.uid() = user_id);
create index events_user_id_idx on events (user_id);
create index events_date_idx    on events (user_id, event_date asc nulls last);
create index events_status_idx  on events (user_id, status);

-- event_recipes
create table event_recipes (
  id                 uuid primary key default gen_random_uuid(),
  event_id           uuid not null references events (id) on delete cascade,
  recipe_id          uuid not null references recipes (id) on delete restrict,
  sort_order         integer not null default 0,
  headcount_override integer check (headcount_override is null or headcount_override > 0),
  notes              text,
  constraint event_recipes_unique unique (event_id, recipe_id)
);
alter table event_recipes enable row level security;
create policy "event_recipes: owner select" on event_recipes for select
  using (exists (select 1 from events e where e.id = event_id and e.user_id = auth.uid()));
create policy "event_recipes: owner insert" on event_recipes for insert
  with check (exists (select 1 from events e where e.id = event_id and e.user_id = auth.uid()));
create policy "event_recipes: owner update" on event_recipes for update
  using (exists (select 1 from events e where e.id = event_id and e.user_id = auth.uid()));
create policy "event_recipes: owner delete" on event_recipes for delete
  using (exists (select 1 from events e where e.id = event_id and e.user_id = auth.uid()));
create index event_recipes_event_id_idx  on event_recipes (event_id);
create index event_recipes_recipe_id_idx on event_recipes (recipe_id);
create index event_recipes_sort_idx      on event_recipes (event_id, sort_order);

-- team_assignments
create table team_assignments (
  id               uuid primary key default gen_random_uuid(),
  event_recipe_id  uuid not null references event_recipes (id) on delete cascade,
  role             assignment_role not null,
  assignee_name    text not null,
  notes            text,
  constraint team_assignments_unique unique (event_recipe_id, role)
);
alter table team_assignments enable row level security;
create policy "team_assignments: owner select" on team_assignments for select
  using (exists (
    select 1 from event_recipes er join events e on e.id = er.event_id
    where er.id = event_recipe_id and e.user_id = auth.uid()
  ));
create policy "team_assignments: owner insert" on team_assignments for insert
  with check (exists (
    select 1 from event_recipes er join events e on e.id = er.event_id
    where er.id = event_recipe_id and e.user_id = auth.uid()
  ));
create policy "team_assignments: owner update" on team_assignments for update
  using (exists (
    select 1 from event_recipes er join events e on e.id = er.event_id
    where er.id = event_recipe_id and e.user_id = auth.uid()
  ));
create policy "team_assignments: owner delete" on team_assignments for delete
  using (exists (
    select 1 from event_recipes er join events e on e.id = er.event_id
    where er.id = event_recipe_id and e.user_id = auth.uid()
  ));
create index team_assignments_event_recipe_id_idx on team_assignments (event_recipe_id);
create index team_assignments_role_idx            on team_assignments (event_recipe_id, role);
'@

# ── supabase/migrations/README.md ────────────────────────────────────────────
Write-File "$root\supabase\migrations\README.md" @'
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
'@

# ── Done ──────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "All files written." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. cd $root"
Write-Host "  2. copy .env.example .env.local"
Write-Host "     (fill in NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY)"
Write-Host "  3. npm install"
Write-Host "  4. npm run dev"
Write-Host "  5. Open http://localhost:3000"
Write-Host ""
Write-Host "Then apply supabase\migrations\001_initial_schema.sql via the Supabase Dashboard SQL Editor." -ForegroundColor Cyan
Write-Host ""