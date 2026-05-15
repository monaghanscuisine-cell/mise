import PageHeader from "@/components/ui/PageHeader"
import EmptyState from "@/components/ui/EmptyState"

export const metadata = { title: "Events" }

export default function EventsPage() {
  return (
    <>
      <PageHeader title="Events" subtitle="Catering jobs and events"
        action={{ label: "+ New Event", href: "/events/new" }} />
      <EmptyState icon="ðŸ“…" heading="No events yet"
        message="Create an event to build a menu, assign your team, and generate print-ready packets."
        action={{ label: "+ New Event", href: "/events/new" }} />
    </>
  )
}