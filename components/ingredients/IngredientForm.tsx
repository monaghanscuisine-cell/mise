'use client'

import { useState } from 'react'
import type { Ingredient, IngredientCategory } from '@/lib/database.types'
import { CATEGORY_CONFIG, CATEGORY_ORDER } from './categoryConfig'

interface IngredientFormProps {
  /** Called with the newly created ingredient on success */
  onCreated: (ingredient: Ingredient) => void
}

const EMPTY = { name: '', category: '' as IngredientCategory | '', default_unit: '' }

export default function IngredientForm({ onCreated }: IngredientFormProps) {
  const [fields, setFields] = useState(EMPTY)
  const [error, setError]   = useState('')
  const [saving, setSaving] = useState(false)

  function set(key: keyof typeof EMPTY, value: string) {
    setFields(f => ({ ...f, [key]: value }))
    if (error) setError('')
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')

    if (!fields.name.trim()) {
      setError('Name is required.')
      return
    }
    if (!fields.category) {
      setError('Category is required.')
      return
    }

    setSaving(true)

    const res = await fetch('/api/ingredients', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        name:         fields.name.trim(),
        category:     fields.category,
        default_unit: fields.default_unit.trim() || undefined,
      }),
    })

    const json = await res.json()
    setSaving(false)

    if (!res.ok) {
      setError(json.error ?? 'Something went wrong.')
      return
    }

    onCreated(json as Ingredient)
    setFields(EMPTY)
  }

  return (
    <form
      onSubmit={handleSubmit}
      className="bg-white border border-mise-rule rounded-lg p-4 mb-6"
      noValidate
    >
      <p className="text-xs text-mise-stone uppercase tracking-wide mb-3">
        Add ingredient
      </p>

      <div className="flex flex-col sm:flex-row gap-3">
        {/* Name */}
        <div className="flex-1 min-w-0">
          <label htmlFor="ing-name" className="sr-only">Name</label>
          <input
            id="ing-name"
            type="text"
            placeholder="Ingredient name"
            value={fields.name}
            onChange={e => set('name', e.target.value)}
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink placeholder:text-mise-rule focus:outline-none focus:border-mise-stone transition-colors"
            autoComplete="off"
          />
        </div>

        {/* Category */}
        <div className="w-full sm:w-44">
          <label htmlFor="ing-category" className="sr-only">Category</label>
          <select
            id="ing-category"
            value={fields.category}
            onChange={e => set('category', e.target.value)}
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink bg-white focus:outline-none focus:border-mise-stone transition-colors"
          >
            <option value="">Category…</option>
            {CATEGORY_ORDER.map(cat => (
              <option key={cat} value={cat}>
                {CATEGORY_CONFIG[cat].label}
              </option>
            ))}
          </select>
        </div>

        {/* Default unit */}
        <div className="w-full sm:w-28">
          <label htmlFor="ing-unit" className="sr-only">Default unit</label>
          <input
            id="ing-unit"
            type="text"
            placeholder="Unit (opt.)"
            value={fields.default_unit}
            onChange={e => set('default_unit', e.target.value)}
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink placeholder:text-mise-rule focus:outline-none focus:border-mise-stone transition-colors"
          />
        </div>

        {/* Submit */}
        <button
          type="submit"
          disabled={saving}
          className="shrink-0 px-4 py-2 bg-mise-ink text-mise-paper text-sm rounded hover:bg-mise-stone transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {saving ? 'Adding…' : '+ Add'}
        </button>
      </div>

      {/* Inline error */}
      {error && (
        <p className="mt-2 text-sm text-mise-rust" role="alert">
          {error}
        </p>
      )}
    </form>
  )
}
