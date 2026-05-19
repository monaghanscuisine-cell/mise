'use client'

/**
 * NavBar — persistent top navigation for all authenticated screens.
 *
 * Renders the Mise wordmark, primary nav links, and a user menu.
 * Active route is highlighted using usePathname().
 *
 * Issue 4: structure and navigation only.
 * Counts (recipes: 12, events: 3) are added in Issues 8 and 13
 * when the real data is queryable.
 */

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { signOut } from '@/app/(app)/actions'

const NAV_LINKS = [
  { href: '/',            label: 'Home'        },
  { href: '/recipes',     label: 'Recipes'     },
  { href: '/events',      label: 'Events'      },
  { href: '/ingredients', label: 'Ingredients' },
] as const

interface NavBarProps {
  email: string
}

export default function NavBar({ email }: NavBarProps) {
  const pathname = usePathname()

  function isActive(href: string) {
    if (href === '/') return pathname === '/'
    return pathname.startsWith(href)
  }

  return (
    <header className="border-b border-mise-rule bg-white print:hidden sticky top-0 z-10">
      <div className="max-w-5xl mx-auto px-4">
        <div className="flex items-center justify-between h-12">

          {/* Wordmark */}
          <Link
            href="/"
            className="font-serif text-base text-mise-ink tracking-tight select-none"
          >
            Mise
          </Link>

          {/* Primary nav */}
          <nav className="flex items-center gap-1" aria-label="Main navigation">
            {NAV_LINKS.map(({ href, label }) => (
              <Link
                key={href}
                href={href}
                className={[
                  'px-3 py-1.5 rounded text-sm transition-colors',
                  isActive(href)
                    ? 'bg-mise-ink text-mise-paper'
                    : 'text-mise-stone hover:text-mise-ink hover:bg-mise-paper',
                ].join(' ')}
              >
                {label}
              </Link>
            ))}
          </nav>

          {/* User menu */}
          <div className="flex items-center gap-3">
            <span className="text-xs text-mise-stone hidden md:block truncate max-w-[180px]">
              {email}
            </span>
            <form action={signOut}>
              <button
                type="submit"
                className="text-xs text-mise-stone hover:text-mise-ink transition-colors"
              >
                Log out
              </button>
            </form>
          </div>

        </div>
      </div>
    </header>
  )
}
