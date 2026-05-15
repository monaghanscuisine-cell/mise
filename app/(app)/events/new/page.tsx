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
          â† Back to Events
        </Link>
      </div>
    </>
  )
}