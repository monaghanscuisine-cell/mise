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