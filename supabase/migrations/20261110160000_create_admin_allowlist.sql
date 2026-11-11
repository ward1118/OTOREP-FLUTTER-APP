create table if not exists public.admin_allowlist (
  email text primary key,
  created_at timestamptz not null default now(),
  constraint admin_allowlist_gmail_only
    check (
      email = lower(email)
      and email ~ '^[a-z0-9._%+-]+@gmail\.com$'
    )
);

alter table public.admin_allowlist enable row level security;

revoke all on table public.admin_allowlist from anon, authenticated;
grant select on table public.admin_allowlist to authenticated;

create policy "Admins can read their own allowlist entry"
  on public.admin_allowlist
  for select
  to authenticated
  using (email = lower((select auth.jwt() ->> 'email')));

-- After creating and confirming the admin user in Supabase Auth, insert the
-- lowercase Gmail address here. Do not grant the client insert/update/delete.
-- insert into public.admin_allowlist (email) values ('replace-with-admin@gmail.com');
