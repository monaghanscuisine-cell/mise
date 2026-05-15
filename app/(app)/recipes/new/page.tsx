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
          â† Back to Recipes
        </Link>
      </div>
    </>
  )
}