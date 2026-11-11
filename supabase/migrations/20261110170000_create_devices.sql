create table if not exists public.devices (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(trim(name)) > 0),
  location text not null check (length(trim(location)) > 0),
  status text not null default 'UP'
    check (status in ('UP', 'WIP', 'DOWN')),
  notes text,
  created_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists devices_name_location_unique
  on public.devices (lower(name), lower(location));

create index if not exists devices_status_idx
  on public.devices (status);

alter table public.devices enable row level security;

revoke all on table public.devices from anon, authenticated;
grant select, insert, update, delete on table public.devices to authenticated;

drop policy if exists "Admins can read devices" on public.devices;
create policy "Admins can read devices"
  on public.devices
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.admin_allowlist
      where email = lower((select auth.jwt() ->> 'email'))
    )
  );

drop policy if exists "Admins can add devices" on public.devices;
create policy "Admins can add devices"
  on public.devices
  for insert
  to authenticated
  with check (
    created_by = (select auth.uid())
    and exists (
      select 1
      from public.admin_allowlist
      where email = lower((select auth.jwt() ->> 'email'))
    )
  );

drop policy if exists "Admins can update devices" on public.devices;
create policy "Admins can update devices"
  on public.devices
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.admin_allowlist
      where email = lower((select auth.jwt() ->> 'email'))
    )
  )
  with check (
    exists (
      select 1
      from public.admin_allowlist
      where email = lower((select auth.jwt() ->> 'email'))
    )
  );

drop policy if exists "Admins can delete devices" on public.devices;
create policy "Admins can delete devices"
  on public.devices
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.admin_allowlist
      where email = lower((select auth.jwt() ->> 'email'))
    )
  );

create or replace function public.set_device_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_device_updated_at on public.devices;
create trigger set_device_updated_at
  before update on public.devices
  for each row
  execute function public.set_device_updated_at();

notify pgrst, 'reload schema';
