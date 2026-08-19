const CACHE='angels-tuna-v29.3-web-lite-1';
const ASSETS=["./underwater-tuna-v25.png", "./_redirects", "./icon-192.png", "./iccat-bft-adriatic-events-v29.csv", "./icon-512.png", "./intro-v20.jpg", "./underwater-tuna-v26.png", "./iccat-bft-adriatic-events-v29.json", "./ocean-background.png", "./index.html", "./manifest.webmanifest", "./_headers", "./SERVER_ANGELS_TUNA.ps1"];
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS)).then(()=>self.skipWaiting())));
self.addEventListener('activate',e=>e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim())));
self.addEventListener('fetch',e=>{
 if(e.request.method!=='GET')return;
 const u=new URL(e.request.url);
 if(u.origin===self.location.origin){
  e.respondWith(fetch(e.request).then(r=>{let cp=r.clone();caches.open(CACHE).then(c=>c.put(e.request,cp));return r})
   .catch(()=>caches.match(e.request).then(r=>r||caches.match('./index.html'))));
 }
});
