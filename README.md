# Angel's Tuna v29.3 — ICCAT MAP EDITION

- Motore mappa separato e robusto.
- Marker ICCAT release/pop-off/recovery.
- EMODnet + spot/catture personali.
- Controlli zoom e layer.
- Tabella ICCAT della v29.2 invariata.

# Angel's Tuna v29.2 — ICCAT Stable Data Module

Questa versione aggiunge un modulo ICCAT indipendente dalla mappa e dal vecchio renderMigration.
Il pannello deve mostrare immediatamente "Dataset ICCAT: 140/140 caricato" e una tabella filtrabile,
anche se Leaflet, EMODnet o la mappa non si inizializzano.

# Angel's Tuna v29.1 — ICCAT Map Fix

- ICCAT dataset embedded directly in index.html as fallback.
- Table of nearest ICCAT endpoints always available even if map tiles fail.
- GPS 'Vicino a me'.
- Fixed migration analysis rendering.
- Bottom navigation renamed ICCAT.

# Angel's Tuna v29 — ICCAT Adriatic Intelligence

La v29 incorpora il dataset filtrato dall'inventario ICCAT fornito dall'utente.
Gli eventi sono visualizzati come endpoint reali: release, pop-off e recovery.
Non vengono trasformati in traiettorie artificiali.

Funzioni nuove:
- 140 eventi ICCAT Adriatico inclusi offline nell'app.
- Filtri per mese, distanza e tipo evento.
- Modalità “Agosto nella mia zona”.
- Release / Pop-off / Recovery distinti sulla mappa.
- EMODnet Bathymetry + spot e catture personali.
- Indicazione esplicita quando un filtro non contiene eventi.
- Nessuna inferenza di presenza attuale del tonno da un endpoint storico.

# Angel's Tuna v28 — Tuna Migration Intelligence

# Angel's Tuna v27 — Lunar Tracker Edition

# Angel's Tuna v26 — Standalone Underwater Edition

# Angel's Tuna v26 — Underwater Edition

# Angel's Tuna v24 — Definitive Memories Edition

## Nuove funzioni
- Foto associata direttamente alla cattura.
- Da iPhone/PWA il campo foto può aprire la fotocamera (`capture=environment`) o la libreria.
- Compressione automatica della foto prima del salvataggio.
- Foto conservate in IndexedDB, non nel localStorage.
- Nuova sezione 📸 Ricordi / Catch Memories.
- Galleria fotografica delle catture.
- Scheda ricordo con specie, peso, data/ora, fondale, profondità esca, temperatura, GPS e note.
- Pulsante “Crea/Condividi Ricordo”:
  genera una card PNG Angel's Tuna pronta per Condividi su iOS quando supportato.
- Collegamento diretto dal ricordo allo Spot Map GPS.
- Backup fotografie separato:
  - esportazione archivio foto JSON;
  - reimportazione archivio foto.
- Eliminando una cattura viene eliminata anche la relativa foto.
- Mantiene tutte le funzioni v23:
  - Spot Map;
  - navigazione GPS verso gli spot;
  - batimetria EMODnet e isobate;
  - piani multi-batimetrica;
  - importazione ChatGPT Plan;
  - intro video.

## Persistenza e aggiornamenti
I dati normali restano nel localStorage del dominio.
Le immagini restano in IndexedDB dello stesso dominio.
Aggiornare il deploy sullo stesso dominio Netlify non cancella automaticamente i dati o le foto.

## Backup consigliato prima di un aggiornamento
1. Esporta backup JSON dei dati.
2. Esporta archivio fotografie dalla sezione Ricordi/Impostazioni.
3. Pubblica la nuova versione sullo stesso dominio.
4. Verifica Diario e Ricordi.

## Nota
Le foto locali possono essere eliminate dal sistema/browser se l'utente cancella i dati del sito.
Per archiviazione permanente è sempre consigliabile mantenere anche il backup foto esportato.

## V26
Nuovo sfondo desktop sottomarino con tonno tra le mangianze, ottimizzato per schermi PC widescreen. Mantiene tutte le funzioni della v24.

## Novità v27
- Nuova sezione 🌙 Fasi lunari.
- Fase lunare per qualsiasi data.
- Percentuale di illuminazione e età lunare.
- Prossima Luna piena e prossima Luna nuova.
- Calendario visuale di 28 giorni.
- Confronto automatico Luna × storico catture.
- Nessuna affermazione che la Luna da sola garantisca la presenza o l'attività del tonno: viene trattata come variabile ambientale da confrontare con i dati reali.


## V28
Nuova sezione Tuna Migration Intelligence. Integra EMODnet Bathymetry, spot e catture GPS personali e permette di importare dataset CSV reali di tagging elettronico. Non simula né inventa tracce di tonni. Le coordinate di tag vengono visualizzate soltanto se presenti nel dataset importato.
