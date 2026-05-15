// Hand-written stub â€” matches 001_initial_schema.sql
// Replace after Issue 6: supabase gen types typescript --linked > lib/database.types.ts

export type IngredientCategory =
  | "produce" | "protein" | "dairy" | "dry_goods"
  | "canned_jarred" | "frozen" | "bread_bakery"
  | "beverage" | "specialty" | "other"

export type EventStatus = "draft" | "confirmed" | "completed" | "cancelled"
export type AssignmentRole = "prep" | "cooking" | "plating" | "packing" | "general"

export type Ingredient = {
  id: string; user_id: string; name: string
  category: IngredientCategory; default_unit: string | null
  notes: string | null; created_at: string
}
export type Recipe = {
  id: string; user_id: string; name: string; description: string | null
  base_yield_quantity: number; base_yield_unit: string
  plating_notes: string | null; timing_notes: string | null; team_notes: string | null
  tags: string[]; is_archived: boolean; created_at: string; updated_at: string
}
export type RecipeIngredient = {
  id: string; recipe_id: string; ingredient_id: string
  quantity: number; unit: string; prep_note: string | null; sort_order: number
}
export type PrepStep = {
  id: string; recipe_id: string; step_number: number
  instruction: string; timing_label: string | null; is_critical: boolean
}
export type CookStep = {
  id: string; recipe_id: string; step_number: number
  instruction: string; timing_label: string | null
}
export type Event = {
  id: string; user_id: string; name: string; event_date: string | null
  service_time: string | null; location: string | null; headcount: number
  notes: string | null; status: EventStatus; created_at: string; updated_at: string
}
export type EventRecipe = {
  id: string; event_id: string; recipe_id: string; sort_order: number
  headcount_override: number | null; notes: string | null
}
export type TeamAssignment = {
  id: string; event_recipe_id: string; role: AssignmentRole
  assignee_name: string; notes: string | null
}

export type IngredientInsert    = Omit<Ingredient,     "id" | "created_at">
export type RecipeInsert        = Omit<Recipe,         "id" | "created_at" | "updated_at">
export type EventInsert         = Omit<Event,          "id" | "created_at" | "updated_at">
export type EventRecipeInsert   = Omit<EventRecipe,    "id">
export type TeamAssignmentInsert = Omit<TeamAssignment, "id">

export type Database = {
  public: {
    Tables: {
      ingredients:        { Row: Ingredient;       Insert: IngredientInsert;        Update: Partial<IngredientInsert>        }
      recipes:            { Row: Recipe;           Insert: RecipeInsert;            Update: Partial<RecipeInsert>            }
      recipe_ingredients: { Row: RecipeIngredient; Insert: Omit<RecipeIngredient,"id">; Update: Partial<Omit<RecipeIngredient,"id">> }
      prep_steps:         { Row: PrepStep;         Insert: Omit<PrepStep,"id">;         Update: Partial<Omit<PrepStep,"id">>         }
      cook_steps:         { Row: CookStep;         Insert: Omit<CookStep,"id">;         Update: Partial<Omit<CookStep,"id">>         }
      events:             { Row: Event;            Insert: EventInsert;             Update: Partial<EventInsert>             }
      event_recipes:      { Row: EventRecipe;      Insert: EventRecipeInsert;       Update: Partial<EventRecipeInsert>       }
      team_assignments:   { Row: TeamAssignment;   Insert: TeamAssignmentInsert;    Update: Partial<TeamAssignmentInsert>    }
    }
    Views: Record<string, never>
    Functions: Record<string, never>
    Enums: {
      ingredient_category: IngredientCategory
      event_status: EventStatus
      assignment_role: AssignmentRole
    }
  }
}