# OTOREP

## Supabase admin login setup

OTOREP uses Supabase Auth for password sign-in and a protected email allowlist
for admin authorization. The app has no public registration or email
verification flow.

1. In Supabase, open **Project Settings → API** and copy your project URL and
   **publishable** key. Never put a `service_role` key in
   the Flutter app.
2. Copy `supabase.local.example.json` to `supabase.local.json`, then replace
   both placeholder values with the URL and publishable key.
3. If `public.admin_allowlist` does not already exist, open
   **SQL Editor → New query** in the Supabase Dashboard. Open
   `supabase/migrations/20261110160000_create_admin_allowlist.sql` in this
   project, copy its full contents into the query, and click **Run**. Do not
   rerun this migration if the allowlist table and its policy are already set
   up.
4. Create another new query. Copy the full contents of
   `supabase/migrations/20261110170000_create_devices.sql` into it and click
   **Run**.    Run the devices migration after the allowlist exists; it depends on that
   table. It creates the `devices` table with name, location,
   status (`UP`, `WIP`, `DOWN`), optional notes, and timestamps, and restricts
   device access to signed-in allowlisted admins.
5. In **Table Editor**, confirm that `public.devices` appears. Then reload the
   app or tap **RETRY** on the Equipment screen.
6. In **Authentication → Providers → Email**, disable email confirmations and
   disable public sign-ups. Only a user you create in the Supabase dashboard
   can sign in; the app's allowlist independently enforces admin access.
7. Create the admin user in the Supabase Auth dashboard using the admin's real
   Gmail address. If that user already exists as unconfirmed, mark its email
   confirmed in the dashboard.
8. Add that same lowercase Gmail to the allowlist from the SQL Editor:

   ```sql
   insert into public.admin_allowlist (email)
   values ('edwardcalayag899@gmail.com');
   ```

9. Start the app from this folder:

   ```powershell
   flutter run --dart-define-from-file=supabase.local.json
   ```

The login screen will not authenticate or open protected pages until Supabase
is configured and the user's Gmail is in the allowlist. The Device and
Equipment screens load device records from the `devices` table. If the app
reports that the table is missing, verify that both migrations ran successfully
in the correct Supabase project and that `public.devices` appears in Table
Editor before retrying.
