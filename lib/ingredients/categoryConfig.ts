import type { IngredientCategory } from '@/lib/database.types'

/**
 * Display config for each ingredient category.
 * Used in badges, dropdowns, and buy list section headers.
 *
 * Colours are intentionally subtle — all outputs must read in greyscale.
 * Badge uses a border + light background rather than a solid colour.
 */
export const CATEGORY_CONFIG: Record<
  IngredientCategory,
  { label: string; badge: string }
> = {
  produce:      { label: 'Produce',       badge: 'bg-green-50  border-green-200  text-green-800'  },
  protein:      { label: 'Protein',       badge: 'bg-red-50    border-red-200    text-red-800'    },
  dairy:        { label: 'Dairy',         badge: 'bg-yellow-50 border-yellow-200 text-yellow-800' },
  dry_goods:    { label: 'Dry Goods',     badge: 'bg-amber-50  border-amber-200  text-amber-800'  },
  canned_jarred:{ label: 'Canned/Jarred', badge: 'bg-stone-50  border-stone-200  text-stone-700'  },
  frozen:       { label: 'Frozen',        badge: 'bg-blue-50   border-blue-200   text-blue-800'   },
  bread_bakery: { label: 'Bread/Bakery',  badge: 'bg-orange-50 border-orange-200 text-orange-800' },
  beverage:     { label: 'Beverage',      badge: 'bg-teal-50   border-teal-200   text-teal-800'   },
  specialty:    { label: 'Specialty',     badge: 'bg-purple-50 border-purple-200 text-purple-800' },
  other:        { label: 'Other',         badge: 'bg-gray-50   border-gray-200   text-gray-600'   },
}

// Ordered list for dropdowns — logical shopping order matches the buy list
export const CATEGORY_ORDER: IngredientCategory[] = [
  'produce',
  'protein',
  'dairy',
  'dry_goods',
  'canned_jarred',
  'frozen',
  'bread_bakery',
  'beverage',
  'specialty',
  'other',
]
