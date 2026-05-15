import PageHeader from "@/components/ui/PageHeader"
import EmptyState from "@/components/ui/EmptyState"

export const metadata = { title: "Recipes" }

export default function RecipesPage() {
  return (
    <>
      <PageHeader title="Recipes" subtitle="Your dish library"
        action={{ label: "+ New Recipe", href: "/recipes/new" }} />
      <EmptyState icon="ðŸ“–" heading="No recipes yet"
        message="Add your first recipe to build your library."
        action={{ label: "+ Add Recipe", href: "/recipes/new" }} />
    </>
  )
}