const CACHE_NAME = 'chrjobs-static-v5';
const APP_SHELL = [
  './',
  './index.html',
  './manifest.json',
  './icon-192.png',
  './icon-512.png',
  './icon.png'
];

const OFFLINE_HTML = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CHR Jobs</title>
  <style>
    body{font-family:Tajawal,Segoe UI,sans-serif;background:#fdfaf7;color:#4e342e;margin:0;display:flex;align-items:center;justify-content:center;min-height:100vh;padding:24px;box-sizing:border-box}
    .box{max-width:420px;background:#fff;border-radius:24px;padding:28px;text-align:center;box-shadow:0 10px 25px rgba(0,0,0,.08)}
    h1{margin:0 0 10px;font-size:22px}
    p{margin:0;color:#6d5b56;line-height:1.6}
  </style>
</head>
<body>
  <div class="box">
    <h1>CHR Jobs</h1>
    <p>You are offline. Please reconnect to load live workers, chat, and announcements.</p>
  </div>
</body>
</html>`;

function isHttpRequest(request) {
  return request.url.startsWith('http://') || request.url.startsWith('https://');
}

function isSameOrigin(request) {
  return new URL(request.url).origin === self.location.origin;
}

function shouldCache(request, response) {
  if (!response || !response.ok || response.type !== 'basic') return false;
  if (!isSameOrigin(request)) return false;

  const cacheableDestinations = new Set([
    'document',
    'image',
    'style',
    'font',
    'manifest'
  ]);

  return cacheableDestinations.has(request.destination);
}

function isFirebaseLikeRequest(request) {
  return /firestore|googleapis|gstatic|firebaseio|cloudfunctions|identitytoolkit/i.test(request.url);
}

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(APP_SHELL))
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
          return Promise.resolve(false);
        })
      )
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const { request } = event;

  if (request.method !== 'GET' || !isHttpRequest(request)) return;
  if (!isSameOrigin(request)) return;
  if (isFirebaseLikeRequest(request)) return;

  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request)
        .then((response) => {
          if (shouldCache(request, response)) {
            const clone = response.clone();
            event.waitUntil(
              caches.open(CACHE_NAME).then((cache) => cache.put(request, clone))
            );
          }
          return response;
        })
        .catch(async () => {
          const cachedPage = await caches.match(request);
          return cachedPage || caches.match('./index.html') || new Response(OFFLINE_HTML, {
            headers: { 'Content-Type': 'text/html; charset=UTF-8' }
          });
        })
    );
    return;
  }

  event.respondWith(
    caches.match(request).then((cached) => {
      if (cached) return cached;

      return fetch(request)
        .then((response) => {
          if (shouldCache(request, response)) {
            const clone = response.clone();
            event.waitUntil(
              caches.open(CACHE_NAME).then((cache) => cache.put(request, clone))
            );
          }
          return response;
        })
        .catch(() => Response.error());
    })
  );
});
