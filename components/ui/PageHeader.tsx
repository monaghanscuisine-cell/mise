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