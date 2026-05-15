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