WAREHOUSE INSPECTION CLOUD v2

Files must be uploaded to the ROOT of the GitHub repository.
Do not upload the ZIP file itself.

1. Upload/replace all files from this folder in GitHub.
2. Keep the icons folder and both PNG files.
3. Open config.js in GitHub and enter:
   window.SUPABASE_URL = "https://YOUR_PROJECT.supabase.co";
   window.SUPABASE_KEY = "YOUR_SUPABASE_PUBLISHABLE_KEY";
   Do NOT add /rest/v1/ to the URL.
4. In Supabase SQL Editor, run schema.sql once.
5. In GitHub Settings -> Pages, publish from main / root.
6. Open the GitHub Pages address.
7. On the login screen press Test Connection.
8. Only after all three checks show OK, create an account.

This version uses sw-v2.js and does not cache config.js, so changing config.js in GitHub will not leave the old configuration stuck in the PWA cache.
