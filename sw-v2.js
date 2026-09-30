const CACHE = "warehouse-cloud-v2";
const CORE = [
  "./",
  "./index.html",
  "./manifest.webmanifest",
  "./icons/icon-192.png",
  "./icons/icon-512.png"
];
self.addEventListener("install", event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(CORE)).then(() => self.skipWaiting()));
});
self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});
self.addEventListener("fetch", event => {
  const url = new URL(event.request.url);
  // Never cache configuration or external APIs/libraries.
  if (url.pathname.endsWith("/config.js") || url.hostname.endsWith("supabase.co") || url.hostname.includes("jsdelivr.net")) return;
  event.respondWith(caches.match(event.request).then(cached => cached || fetch(event.request)));
});
