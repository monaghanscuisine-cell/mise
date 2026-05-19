'use client'

/**
 * IngredientList — client component that owns the ingredient state.
 *
 * Receives the initial list from the Server Component (no loading flicker),
 * then updates it optimistically when a new ingredient is added via the form.
 * No page reload needed.
 */

import { useState } from 'react'
import type { Ingredient } from '@/lib/database.types'
import { CATEGORY_CONFIG, CATEGORY_ORDER } from './categoryConfig'
import IngredientForm from './IngredientForm'
import EmptyState from '@/components/ui/EmptyState'

interface IngredientListProps {
  initialIngredients: Ingredient[]
}

function CategoryBadge({ category }: { category: Ingredient['category'] }) {
  const cfg = CATEGORY_CONFIG[category]
  return (
    <span
      className={`inline-flex items-center px-2 py-0.5 rounded border text-xs ${cfg.badge}`}
    >
      {cfg.label}
    </span>
  )
}

export default function IngredientList({ initialIngredients }: IngredientListProps) {
  const [ingredients, setIngredients] = useState<Ingredient[]>(initialIngredients)

  function handleCreated(ingredient: Ingredient) {
    // Insert in alphabetical position
    setIngredients(prev => {
      const next = [...prev, ingredient]
      return next.sort((a, b) => a.name.localeCompare(b.name))
    })
  }

  return (
    <>
      <IngredientForm onCreated={handleCreated} />

      {ingredients.length === 0 ? (
        <EmptyState
          heading="No ingredients yet"
          message="Add your first ingredient above. Your library powers autocomplete in the recipe builder and category grouping in the buy list."
        />
      ) : (
        <>
          {/* Count */}
          <p className="text-xs text-mise-stone mb-3">
            {ingredients.length} {ingredients.length === 1 ? 'ingredient' : 'ingredients'}
          </p>

          {/* Table */}
          <div className="border border-mise-rule rounded-lg overflow-hidden">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-mise-rule bg-mise-paper">
                  <th className="text-left px-4 py-2.5 text-xs text-mise-stone font-normal uppercase tracking-wide">
                    Name
                  </th>
                  <th className="text-left px-4 py-2.5 text-xs text-mise-stone font-normal uppercase tracking-wide">
                    Category
                  </th>
                  <th className="text-left px-4 py-2.5 text-xs text-mise-stone font-normal uppercase tracking-wide hidden sm:table-cell">
                    Default unit
                  </th>
                </tr>
              </thead>
              <tbody>
                {ingredients.map((ing, i) => (
                  <tr
                    key={ing.id}
                    className={[
                      'hover:bg-mise-paper transition-colors',
                      i < ingredients.length - 1 ? 'border-b border-mise-rule' : '',
                    ].join(' ')}
                  >
                    <td className="px-4 py-3 text-mise-ink font-medium">
                      {ing.name}
                    </td>
                    <td className="px-4 py-3">
                      <CategoryBadge category={ing.category} />
                    </td>
                    <td className="px-4 py-3 text-mise-stone hidden sm:table-cell">
                      {ing.default_unit ?? (
                        <span className="text-mise-rule">—</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Category breakdown — useful quick-reference */}
          <div className="mt-6 pt-4 border-t border-mise-rule">
            <p className="text-xs text-mise-stone mb-2 uppercase tracking-wide">
              By category
            </p>
            <div className="flex flex-wrap gap-2">
              {CATEGORY_ORDER.map(cat => {
                const count = ingredients.filter(i => i.category === cat).length
                if (count === 0) return null
                return (
                  <span
                    key={cat}
                    className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded border text-xs ${CATEGORY_CONFIG[cat].badge}`}
                  >
                    {CATEGORY_CONFIG[cat].label}
                    <span className="font-medium">{count}</span>
                  </span>
                )
              })}
            </div>
          </div>
        </>
      )}
    </>
  )
}
