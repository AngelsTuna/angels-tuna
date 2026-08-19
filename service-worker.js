const CACHE='angels-tuna-v29.4-github-full-1';
const ASSETS=["./ISTRUZIONI_PC_CORRETTE.txt", "./underwater-tuna-v25.png", "./_redirects", "./icon-192.png", "./underwater-tuna-v29.png", "./iccat-bft-adriatic-events-v29.csv", "./icon-512.png", "./README.md", "./CLOUDFLARE-ISTRUZIONI.txt", "./intro-v20.jpg", "./underwater-tuna-v26.png", "./iccat-bft-adriatic-events-v29.json", "./ISTRUZIONI_PC.txt", "./ocean-background.png", "./index.html", "./manifest.webmanifest", "./intro-video.mp4", "./_headers", "./SCIENTIFIC_MODEL_NOTES.md", "./SERVER_ANGELS_TUNA.ps1"];
self.addEventListener('install',event=>{
  event.waitUntil(caches.open(CACHE).then(cache=>cache.addAll(ASSETS)).then(()=>self.skipWaiting()));
});
self.addEventListener('activate',event=>{
  event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim()));
});
self.addEventListener('fetch',event=>{
  if(event.request.method!=='GET') return;
  const url=new URL(event.request.url);
  if(url.origin===self.location.origin){
    event.respondWith(
      fetch(event.request).then(resp=>{
        const copy=resp.clone();
        caches.open(CACHE).then(cache=>cache.put(event.request,copy));
        return resp;
      }).catch(()=>caches.match(event.request).then(resp=>resp||caches.match('./index.html')))
    );
  }
});
