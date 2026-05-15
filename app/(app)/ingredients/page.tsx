import PageHeader from "@/components/ui/PageHeader"
import EmptyState from "@/components/ui/EmptyState"

export const metadata = { title: "Ingredients" }

export default function IngredientsPage() {
  return (
    <>
      <PageHeader title="Ingredients" subtitle="Shared ingredient library" />
      <EmptyState icon="ðŸ§…" heading="No ingredients yet"
        message="Your ingredient library powers autocomplete in the recipe builder and category grouping in the buy list." />
    </>
  )
}