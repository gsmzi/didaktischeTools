// Ersetzt den Service Worker der alten Adresse: Cache löschen, abmelden, offene Fenster neu laden.
// Beim Neuladen greift die 404.html und leitet auf /lernwerkzeuge/ weiter.
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(k => Promise.all(k.map(x => caches.delete(x))))
      .then(() => self.registration.unregister())
      .then(() => self.clients.matchAll({ type: 'window' }))
      .then(cs => Promise.all(cs.map(c => c.navigate(c.url).catch(() => {}))))
  );
});
