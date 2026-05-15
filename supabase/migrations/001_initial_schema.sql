-- Mise Initial Schema
create extension if not exists moddatetime schema extensions;

create type ingredient_category as enum (
  ''produce'',''protein'',''dairy'',''dry_goods'',''canned_jarred'',
  ''frozen'',''bread_bakery'',''beverage'',''specialty'',''other''
);
create type event_status as enum (''draft'',''confirmed'',''completed'',''cancelled'');
create type assignment_role as enum (''prep'',''cooking'',''plating'',''packing'',''general'');

-- ingredients
create table ingredients (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  name         text not null,
  category     ingredient_category not null default ''other'',
  default_unit text,
  notes        text,
  created_at   timestamptz not null default now(),
  constraint ingredients_user_name_unique unique (user_id, name)
);
alter table ingredients enable row level security;
create policy "ingredients: owner select" on ingredients for select using (auth.uid() = user_id);
create policy "ingredients: owner insert" on ingredients for insert with check (auth.uid() = user_id);
create policy "ingredients: owner update" on ingredients for update using (auth.uid() = user_id);
create policy "ingredients: owner delete" on ingredients for delete using (auth.uid() = user_id);
create index ingredients_user_id_idx  on ingredients (user_id);
create index ingredients_name_idx     on ingredients (user_id, lower(name));
create index ingredients_category_idx on ingredients (user_id, category);

-- recipes
create table recipes (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references auth.users (id) on delete cascade,
  name                text not null,
  description         text,
  base_yield_quantity numeric not null default 1 check (base_yield_quantity > 0),
  base_yield_unit     text not null default ''portions'',
  plating_notes       text,
  timing_notes        text,
  team_notes          text,
  tags                text[] not null default ''{}''::text[],
  is_archived         boolean not null default false,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);
create trigger recipes_updated_at before update on recipes
  for each row execute procedure extensions.moddatetime(updated_at);
alter table recipes enable row level security;
create policy "recipes: owner select" on recipes for select using (auth.uid() = user_id);
create policy "recipes: owner insert" on recipes for insert with check (auth.uid() = user_id);
create policy "recipes: owner update" on recipes for update using (auth.uid() = user_id);
create policy "recipes: owner delete" on recipes for delete using (auth.uid() = user_id);
create index recipes_user_id_idx    on recipes (user_id);
create index recipes_updated_at_idx on recipes (user_id, updated_at desc);
create index recipes_archived_idx   on recipes (user_id, is_archived);
create index recipes_tags_idx       on recipes using gin (tags);

-- recipe_ingredients
create table recipe_ingredients (
  id            uuid primary key default gen_random_uuid(),
  recipe_id     uuid not null references recipes (id) on delete cascade,
  ingredient_id uuid not null references ingredients (id) on delete restrict,
  quantity      numeric not null check (quantity > 0),
  unit          text not null,
  prep_note     text,
  sort_order    integer not null default 0
);
alter table recipe_ingredients enable row level security;
create policy "recipe_ingredients: owner select" on recipe_ingredients for select
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "recipe_ingredients: owner insert" on recipe_ingredients for insert
  with check (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "recipe_ingredients: owner update" on recipe_ingredients for update
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "recipe_ingredients: owner delete" on recipe_ingredients for delete
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create index recipe_ingredients_recipe_id_idx     on recipe_ingredients (recipe_id);
create index recipe_ingredients_ingredient_id_idx on recipe_ingredients (ingredient_id);
create index recipe_ingredients_sort_idx          on recipe_ingredients (recipe_id, sort_order);

-- prep_steps
create table prep_steps (
  id           uuid primary key default gen_random_uuid(),
  recipe_id    uuid not null references recipes (id) on delete cascade,
  step_number  integer not null check (step_number > 0),
  instruction  text not null,
  timing_label text,
  is_critical  boolean not null default false,
  constraint prep_steps_recipe_step_unique unique (recipe_id, step_number)
);
alter table prep_steps enable row level security;
create policy "prep_steps: owner select" on prep_steps for select
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "prep_steps: owner insert" on prep_steps for insert
  with check (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "prep_steps: owner update" on prep_steps for update
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "prep_steps: owner delete" on prep_steps for delete
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create index prep_steps_recipe_id_idx  on prep_steps (recipe_id);
create index prep_steps_step_order_idx on prep_steps (recipe_id, step_number);

-- cook_steps
create table cook_steps (
  id           uuid primary key default gen_random_uuid(),
  recipe_id    uuid not null references recipes (id) on delete cascade,
  step_number  integer not null check (step_number > 0),
  instruction  text not null,
  timing_label text,
  constraint cook_steps_recipe_step_unique unique (recipe_id, step_number)
);
alter table cook_steps enable row level security;
create policy "cook_steps: owner select" on cook_steps for select
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "cook_steps: owner insert" on cook_steps for insert
  with check (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "cook_steps: owner update" on cook_steps for update
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create policy "cook_steps: owner delete" on cook_steps for delete
  using (exists (select 1 from recipes r where r.id = recipe_id and r.user_id = auth.uid()));
create index cook_steps_recipe_id_idx  on cook_steps (recipe_id);
create index cook_steps_step_order_idx on cook_steps (recipe_id, step_number);

-- events
create table events (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  name         text not null,
  event_date   date,
  service_time time,
  location     text,
  headcount    integer not null check (headcount > 0),
  notes        text,
  status       event_status not null default ''draft'',
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create trigger events_updated_at before update on events
  for each row execute procedure extensions.moddatetime(updated_at);
alter table events enable row level security;
create policy "events: owner select" on events for select using (auth.uid() = user_id);
create policy "events: owner insert" on events for insert with check (auth.uid() = user_id);
create policy "events: owner update" on events for update using (auth.uid() = user_id);
create policy "events: owner delete" on events for delete using (auth.uid() = user_id);
create index events_user_id_idx on events (user_id);
create index events_date_idx    on events (user_id, event_date asc nulls last);
create index events_status_idx  on events (user_id, status);

-- event_recipes
create table event_recipes (
  id                 uuid primary key default gen_random_uuid(),
  event_id           uuid not null references events (id) on delete cascade,
  recipe_id          uuid not null references recipes (id) on delete restrict,
  sort_order         integer not null default 0,
  headcount_override integer check (headcount_override is null or headcount_override > 0),
  notes              text,
  constraint event_recipes_unique unique (event_id, recipe_id)
);
alter table event_recipes enable row level security;
create policy "event_recipes: owner select" on event_recipes for select
  using (exists (select 1 from events e where e.id = event_id and e.user_id = auth.uid()));
create policy "event_recipes: owner insert" on event_recipes for insert
  with check (exists (select 1 from events e where e.id = event_id and e.user_id = auth.uid()));
create policy "event_recipes: owner update" on event_recipes for update
  using (exists (select 1 from events e where e.id = event_id and e.user_id = auth.uid()));
create policy "event_recipes: owner delete" on event_recipes for delete
  using (exists (select 1 from events e where e.id = event_id and e.user_id = auth.uid()));
create index event_recipes_event_id_idx  on event_recipes (event_id);
create index event_recipes_recipe_id_idx on event_recipes (recipe_id);
create index event_recipes_sort_idx      on event_recipes (event_id, sort_order);

-- team_assignments
create table team_assignments (
  id               uuid primary key default gen_random_uuid(),
  event_recipe_id  uuid not null references event_recipes (id) on delete cascade,
  role             assignment_role not null,
  assignee_name    text not null,
  notes            text,
  constraint team_assignments_unique unique (event_recipe_id, role)
);
alter table team_assignments enable row level security;
create policy "team_assignments: owner select" on team_assignments for select
  using (exists (
    select 1 from event_recipes er join events e on e.id = er.event_id
    where er.id = event_recipe_id and e.user_id = auth.uid()
  ));
create policy "team_assignments: owner insert" on team_assignments for insert
  with check (exists (
    select 1 from event_recipes er join events e on e.id = er.event_id
    where er.id = event_recipe_id and e.user_id = auth.uid()
  ));
create policy "team_assignments: owner update" on team_assignments for update
  using (exists (
    select 1 from event_recipes er join events e on e.id = er.event_id
    where er.id = event_recipe_id and e.user_id = auth.uid()
  ));
create policy "team_assignments: owner delete" on team_assignments for delete
  using (exists (
    select 1 from event_recipes er join events e on e.id = er.event_id
    where er.id = event_recipe_id and e.user_id = auth.uid()
  ));
create index team_assignments_event_recipe_id_idx on team_assignments (event_recipe_id);
create index team_assignments_role_idx            on team_assignments (event_recipe_id, role);