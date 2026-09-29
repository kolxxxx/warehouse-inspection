
-- TERMINAL WAREHOUSE INSPECTION
-- Run this entire script in Supabase SQL Editor.

create table if not exists public.warehouses (
  id bigint primary key,
  name text not null,
  active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

insert into public.warehouses (id,name,sort_order)
select i, 'Warehouse ' || i, i
from generate_series(1,15) i
on conflict (id) do nothing;

create table if not exists public.inspections (
  id uuid primary key default gen_random_uuid(),
  warehouse_id bigint not null references public.warehouses(id) on delete restrict,
  inspector text not null,
  inspection_date date not null default current_date,
  overall_comment text,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now()
);

create table if not exists public.inspection_items (
  id uuid primary key default gen_random_uuid(),
  inspection_id uuid not null references public.inspections(id) on delete cascade,
  area text not null,
  status text not null check (status in ('OK','Attention','Critical','N/A')),
  finding text,
  created_at timestamptz not null default now()
);

create table if not exists public.defects (
  id uuid primary key default gen_random_uuid(),
  inspection_id uuid references public.inspections(id) on delete set null,
  warehouse_id bigint not null references public.warehouses(id) on delete restrict,
  area text not null,
  description text not null,
  priority text not null check (priority in ('Attention','Critical')),
  responsible text,
  due_date date,
  status text not null default 'Open' check (status in ('Open','In Progress','Closed')),
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now()
);

create table if not exists public.inspection_photos (
  id uuid primary key default gen_random_uuid(),
  inspection_id uuid not null references public.inspections(id) on delete cascade,
  area text not null,
  storage_path text not null,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now()
);

alter table public.warehouses enable row level security;
alter table public.inspections enable row level security;
alter table public.inspection_items enable row level security;
alter table public.defects enable row level security;
alter table public.inspection_photos enable row level security;

drop policy if exists "authenticated warehouses select" on public.warehouses;
create policy "authenticated warehouses select" on public.warehouses
for select to authenticated using (true);

drop policy if exists "authenticated warehouses update" on public.warehouses;
create policy "authenticated warehouses update" on public.warehouses
for update to authenticated using (true) with check (true);

drop policy if exists "authenticated warehouses insert" on public.warehouses;
create policy "authenticated warehouses insert" on public.warehouses
for insert to authenticated with check (true);

drop policy if exists "authenticated warehouses delete" on public.warehouses;
create policy "authenticated warehouses delete" on public.warehouses
for delete to authenticated using (true);

drop policy if exists "authenticated inspections all" on public.inspections;
create policy "authenticated inspections all" on public.inspections
for all to authenticated using (true) with check (true);

drop policy if exists "authenticated items all" on public.inspection_items;
create policy "authenticated items all" on public.inspection_items
for all to authenticated using (true) with check (true);

drop policy if exists "authenticated defects all" on public.defects;
create policy "authenticated defects all" on public.defects
for all to authenticated using (true) with check (true);

drop policy if exists "authenticated photos all" on public.inspection_photos;
create policy "authenticated photos all" on public.inspection_photos
for all to authenticated using (true) with check (true);

-- Storage bucket for inspection photos.
insert into storage.buckets (id,name,public)
values ('inspection-photos','inspection-photos',false)
on conflict (id) do nothing;

drop policy if exists "authenticated photo upload" on storage.objects;
create policy "authenticated photo upload" on storage.objects
for insert to authenticated
with check (bucket_id = 'inspection-photos');

drop policy if exists "authenticated photo read" on storage.objects;
create policy "authenticated photo read" on storage.objects
for select to authenticated
using (bucket_id = 'inspection-photos');

drop policy if exists "authenticated photo delete" on storage.objects;
create policy "authenticated photo delete" on storage.objects
for delete to authenticated
using (bucket_id = 'inspection-photos');
