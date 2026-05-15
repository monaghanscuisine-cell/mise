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
        <NavCard href="/recipes" label="Recipes" count={0} description="Your dish library. Scale to any headcount." icon="ðŸ“–" />
        <NavCard href="/events"  label="Events"  count={0} description="Build menus, assign team, print packets."   icon="ðŸ“…" />
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