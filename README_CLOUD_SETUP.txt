TERMINAL WAREHOUSE INSPECTION — CLOUD VERSION

This is the shared multi-device version.

Architecture:
- Frontend: PWA / static web app
- Database: Supabase PostgreSQL
- Authentication: Supabase Auth
- Photos: Supabase Storage
- Hosting: GitHub Pages (free)
- Mobile: installable on iPhone and Android

SETUP:
1. Create a free Supabase project.
2. Open Supabase SQL Editor and run schema.sql.
3. In Supabase Dashboard -> Project Settings -> API, copy:
   - Project URL
   - Publishable key
4. Open config.js and replace YOUR_SUPABASE_URL and YOUR_SUPABASE_PUBLISHABLE_KEY.
5. Upload the complete folder to a GitHub repository.
6. Enable GitHub Pages from Settings -> Pages -> Deploy from branch -> main -> root.
7. Open the HTTPS GitHub Pages URL on iPhone/Android.
8. Create user accounts from the app or Supabase Authentication.

IMPORTANT:
- RLS policies in schema.sql restrict database access to authenticated users.
- The publishable key is intended for frontend use; never put a service_role/secret key in config.js.
- Free Supabase currently includes 500 MB database size and 1 GB Storage. Photos should be compressed in a future version if usage becomes high.
