# FotoFest
Jasmin-Andreas Wedding 2026
# HochzeitsSnap – Projektplan
## Foto-App & Webseite für Jasmin & Andreas · 16. Mai 2026

---

## 1. Stilanalyse der WeddyBird-Seite

### Farbpalette (aus dem Farbkonzept-Bild extrahiert)
| Farbe | Hex (ca.) | Verwendung |
|-------|-----------|------------|
| Zartes Rosa | `#E8C4C4` | Hintergrund-Akzent, Icons |
| Dusty Rose | `#D4A0A0` | Icon-Kreise im Tagesablauf |
| Lachs/Peach | `#D9A08E` | Farbkonzept-Block |
| Salbeigrün hell | `#A8B5A0` | Farbkonzept-Block |
| Salbeigrün dunkel | `#8A9A7E` | Farbkonzept-Block |
| Creme/Elfenbein | `#FAF7F4` | Seitenhintergrund |
| Dunkelbraun/Bordeaux | `#5C3A3A` | Schriftfarbe Überschriften |

### Typografie-Muster
- **Überschriften**: Kalligraphische Schreibschrift (ähnlich *Great Vibes* oder *Tangerine*)
- **Fließtext**: Serifenlose Schrift, leicht, elegant
- **Navigation**: Schlicht, Serifenlos, dezent
- **"Jasmin und Andreas"** im Logo: Handschrift-Stil, Dunkelbraun

### Design-Elemente
- Zentrierte Layouts mit viel Weißraum
- Horizontale Trennlinien (dünn, dezent, in Rosé)
- Runde Icon-Kreise (Dusty Rose Hintergrund, weiße Icons)
- Countdown-Funktion
- Abwechselnd weiß und cremefarbene Sektionen
- Kein visuelles "Rauschen" – alles ist ruhig und elegant

### Interaktionsmuster
- Passwortgeschützt (nur eingeladene Gäste)
- Online-Rückmeldung mit Menüauswahl
- Ansprechpartner mit Telefonnummern
- Gäste-Upload in Fotogalerie (WeddyBird-Feature)

---

## 2. Konzept: Was wird gebaut?

### Zwei Produkte, ein System:

#### A) iOS-App „HochzeitsSnap" (Swift/SwiftUI, Xcode)
Die App, die Gäste am Hochzeitstag auf ihren iPhones nutzen.

**Kernfunktionen:**
- Kamera-Integration (Foto + Video)
- Automatischer Upload in die Cloud
- Gemeinsame Galerie (alle Gäste sehen alle Fotos)
- Foto-Challenges / Aufgaben
- Tagesablauf-Anzeige (Timeline wie auf der WeddyBird-Seite)
- Download einzelner Fotos
- Push-Notifications (optional: „Jasmin wirft den Brautstrauß!")

**Designvorgabe:** Exakt der WeddyBird-Stil – Schreibschrift-Überschriften, Dusty Rose Akzente, Salbeigrün, viel Weißraum.

#### B) Begleit-Webseite (gehostet für 1 Jahr)
Für Gäste ohne iPhone und als dauerhaftes Archiv.

**Kernfunktionen:**
- Responsive Web-Galerie (alle Fotos durchsuchbar)
- Download aller Fotos als ZIP
- Einzeldownloads in Originalqualität
- QR-Code-Landingpage
- Optionaler Upload via Browser (für Android-Gäste)
- Gästebuch / Kommentarfunktion

---

## 3. Architektur-Entscheidungen

### Die große Frage: Wo liegen die Fotos?

**Option A: Firebase (Empfohlen)**
- Firebase Storage für Bilder (5 GB kostenlos, darüber ~$0.026/GB)
- Firebase Realtime Database / Firestore für Metadaten
- Firebase Auth für Zugang (anonyme Auth mit Event-Code)
- Firebase Hosting für die Webseite
- **Vorteil:** Swift SDK exzellent, kostenloser Einstieg, skaliert automatisch
- **Kosten für 1 Jahr:** Realistisch 0-20€ bei ~100 Gästen und ~2000 Fotos

**Option B: Eigener Server (VPS)**
- Hetzner Cloud (ab ~4€/Monat)
- Swift Vapor Backend oder einfaches Node.js/Python
- PostgreSQL + S3-kompatibler Storage (Hetzner Object Storage: ~1€/TB)
- **Vorteil:** Volle Kontrolle, Domain pelczer.de nutzbar
- **Nachteil:** Mehr Arbeit, Wartung

**Option C: CloudKit (Apple-nativ)**
- Direkt in Swift integriert, kein separates Backend
- **Nachteil:** Nur für Apple-Nutzer, kein Web-Zugang

**Empfehlung:** Firebase. Es ist das Werkzeug, das am besten zu „ich will es selbst bauen, aber es soll zuverlässig funktionieren" passt. Die Webseite kann als statische Seite auf Firebase Hosting laufen oder auf deinem eigenen Server.

### App-Verteilung: TestFlight
Da die App nur für ein Event ist, brauchst du keinen App Store Release:
- TestFlight erlaubt bis zu **10.000 externe Tester** (mehr als genug)
- Einladung per Link oder E-Mail
- Kein App Store Review nötig (nur TestFlight Review, dauert ~24h)
- Gültig für 90 Tage (perfekt für Hochzeitszeitraum)

### Alternative für Android-Gäste
- Die **Webseite** ist der Fallback für alle, die kein iPhone haben
- Progressive Web App (PWA) mit Kamera-Zugang wäre möglich
- Oder einfach: Browser-Upload via Web-Formular

---

## 4. Datenmodell

```
Event
├── eventCode: "jasmin-andreas-1605"
├── eventDate: 2026-05-16
├── eventName: "Jasmin und Andreas"
├── password: "..." (hashed)
│
├── Photos[]
│   ├── id: UUID
│   ├── uploadedBy: "Onkel Andreas" (Gastname)
│   ├── timestamp: DateTime
│   ├── storageURL: "gs://..."
│   ├── thumbnailURL: "gs://..."
│   ├── originalFilename: String
│   ├── sizeBytes: Int
│   ├── challenge: String? (welche Aufgabe)
│   ├── likes: Int
│   └── isVideo: Bool
│
├── Challenges[]
│   ├── id: UUID
│   ├── title: "Fotografiere den ältesten Gast"
│   ├── icon: "person.fill"  (SF Symbol)
│   └── completedBy: [GuestName]
│
├── Timeline[]
│   ├── time: "13:00"
│   ├── title: "Ankunft der Gäste"
│   ├── icon: "bouquet" 
│   └── isActive: Bool (für Live-Highlight)
│
└── Guests[]
    ├── name: String
    ├── deviceId: String
    └── photoCount: Int
```

---

## 5. App-Screens (SwiftUI Views)

### Screen 1: Willkommen / Login
- Großer kalligraphischer Titel: „Jasmin und Andreas"
- Datum: „16. Mai 2026"
- Eingabefeld: „Event-Code eingeben" oder QR-Code scannen
- Eingabefeld: „Dein Name" (für Foto-Zuordnung)
- Dusty-Rose-Button: „Eintreten"
- Hintergrund: Creme/Elfenbein

### Screen 2: Galerie (Hauptscreen)
- Tab Bar mit 4 Tabs:
  - 📸 Galerie
  - 🎯 Challenges
  - 📋 Ablauf
  - ⚙️ Mehr
- Galerie: Masonry-Grid oder 3-Spalten-Grid
- Fotos laden in Echtzeit nach (Firestore Listener)
- Pull-to-Refresh
- Floating Action Button: Kamera (Dusty Rose Kreis)

### Screen 3: Kamera / Upload
- Native Kamera-Integration (UIImagePickerController oder eigener Camera-View)
- Nach Foto: Preview + optionale Challenge-Zuordnung
- Upload-Animation (Dusty Rose Fortschrittsbalken)
- Auch: Aus Fotoalbum wählen (mehrere gleichzeitig)

### Screen 4: Foto-Detail
- Vollbild-Ansicht
- Fotografenname + Zeitstempel
- Like-Button (Herz in Dusty Rose)
- Download-Button
- Share-Button

### Screen 5: Challenges
- Liste der Foto-Aufgaben
- Visuell wie die Timeline auf der WeddyBird-Seite
- Erledigte Aufgaben: Grün markiert mit Foto-Preview
- Beispiel-Aufgaben:
  - „Mach ein Selfie mit dem Brautpaar"
  - „Fotografiere den schönsten Blumenstrauß"
  - „Fang einen lustigen Moment auf der Tanzfläche ein"
  - „Zeig uns dein Outfit"
  - „Wer hat die verrücktesten Schuhe?"

### Screen 6: Tagesablauf
- Exakte Nachbildung der WeddyBird-Timeline:
  - 13:00 Ankunft der Gäste
  - 13:30 Freie Trauung
  - 14:30 Sektempfang und Gratulation
  - 16:00 Kaffee und Kuchen
  - 18:00 Abendessen
  - 21:00 Hochzeitstanz mit anschließender Party
  - 00:00 Ende der Feier
- Aktuelle Phase hervorgehoben (Live-Update)

---

## 6. Webseite: Struktur

**Tech-Stack:** HTML/CSS/JavaScript (statisch) + Firebase JS SDK

### Seiten:
1. **Landingpage** – QR-Code führt hierher
   - „Jasmin & Andreas · 16. Mai 2026"
   - App-Download-Link (TestFlight)
   - Browser-Upload für Android/Desktop
   
2. **Galerie** – Alle Fotos, filterbar nach Zeit/Challenge/Fotograf
   - Lightbox-Ansicht
   - Download einzeln oder alle (ZIP-Generator)
   
3. **Upload** – Drag & Drop oder Kamera-Zugang
   - Name eingeben
   - Challenge auswählen (optional)
   
4. **Gästebuch** – Texteinträge mit Foto

### Design: 
- Identischer Stil wie WeddyBird
- Google Fonts: *Great Vibes* (Überschriften), *Lato* oder *Open Sans* (Text)
- CSS-Variablen für die Farbpalette
- Mobile-First responsive

---

## 7. Zeitplan (83 Tage bis zur Hochzeit)

### Phase 1: Grundlagen (Woche 1-2, bis ~7. März)
- [ ] Firebase-Projekt aufsetzen
- [ ] Xcode-Projekt erstellen, SwiftUI-Grundstruktur
- [ ] Farbpalette + Fonts definieren (Design System)
- [ ] Datenmodell in Firestore anlegen
- [ ] Auth-Flow (Event-Code + Gastname)
- [ ] Basis-Webseite (Landingpage)

### Phase 2: Kernfunktionen (Woche 3-5, bis ~28. März)
- [ ] Kamera-Integration + Foto-Upload
- [ ] Galerie-View mit Echtzeit-Updates
- [ ] Foto-Detail + Download
- [ ] Challenges-System
- [ ] Timeline-View
- [ ] Web-Upload für Android-Gäste
- [ ] Web-Galerie mit Lightbox

### Phase 3: Polish & Features (Woche 6-8, bis ~18. April)
- [ ] Thumbnail-Generierung (Cloud Function)
- [ ] ZIP-Download auf der Webseite
- [ ] Push Notifications (optional)
- [ ] Like-System
- [ ] Animations + Übergangseffekte
- [ ] Dark Mode Support (optional)
- [ ] Accessibility

### Phase 4: Test & Deploy (Woche 9-10, bis ~2. Mai)
- [ ] TestFlight Upload
- [ ] Beta-Test (du selbst + 2-3 Vertraute)
- [ ] Webseite auf Domain deployen
- [ ] QR-Code-Karten drucken
- [ ] Stresstest (viele Fotos gleichzeitig)
- [ ] Offline-Modus testen (queued uploads)

### Phase 5: Hochzeitstag (Woche 11-12)
- [ ] Trauzeugen (Elena/Daniel) einweihen
- [ ] QR-Code-Karten auf Tische verteilen
- [ ] App + Webseite live schalten
- [ ] Monitoring (Firebase Console)
- [ ] 🎉 Hochzeitstag! 🎉

### Phase 6: Nach der Hochzeit
- [ ] Professionelle Fotos des Fotografen hinzufügen
- [ ] Webseite bleibt 1 Jahr online
- [ ] Brautpaar erhält Zugang zum Admin-Bereich
- [ ] ZIP-Download aller Fotos anbieten

---

## 8. Koordination mit Trauzeugen

### Kontaktaufnahme (bald, aber erst nach dem 1. März – Rückmeldefrist!)
Wer: **Elena** (Trauzeugin) und **Daniel** (Trauzeuge)

### Was besprechen:
1. Idee vorstellen: „Ich baue eine Foto-App als Geschenk"
2. Klären: Hat das Brautpaar schon eine Foto-Lösung geplant?
3. QR-Code-Karten – wer stellt sie auf die Tische?
4. Braucht die Location WLAN? (KRITISCH!)
5. Soll ein Bildschirm/Beamer für Live-Diashow organisiert werden?
6. TestFlight-Einladung an 5-10 Test-Gäste vor der Hochzeit

### WLAN-Check!
Die App braucht Internet. Kläre mit Elena/Daniel:
- Hat die Location WLAN?
- Ist ein mobiler Hotspot nötig?
- Alternativ: Offline-Queue (Fotos werden lokal gespeichert und bei Verbindung hochgeladen)

---

## 9. QR-Code-Tischkarten – Design

### Stil (passend zur WeddyBird-Seite):
```
┌─────────────────────────────┐
│                             │
│    𝒥𝒶𝓈𝓂𝒾𝓃 & 𝒜𝓃𝒹𝓇𝑒𝒶𝓈     │
│       16. Mai 2026          │
│                             │
│      ┌─────────────┐        │
│      │   QR-CODE   │        │
│      │             │        │
│      └─────────────┘        │
│                             │
│   Haltet eure schönsten     │
│   Momente fest!             │
│                             │
│   📸 Scannt den Code und    │
│   teilt eure Fotos mit uns  │
│                             │
│   ─── ♡ ───                 │
│                             │
│  Event-Code: jasmin1605     │
│                             │
└─────────────────────────────┘
```

- Gedruckt auf hochwertigem Papier (300g Creme)
- Format: A6 oder Visitenkarte
- Rückseite: Kurzanleitung für Android-Gäste (Webseite-URL)

---

## 10. Must-Have vs. Nice-to-Have

### Must-Have (MVP für den Hochzeitstag):
- ✅ Foto-Upload von iPhone
- ✅ Gemeinsame Galerie
- ✅ Web-Upload für Android-Gäste
- ✅ Foto-Download (einzeln)
- ✅ QR-Code-Zugang
- ✅ Event-Code-Schutz
- ✅ Tagesablauf

### Nice-to-Have:
- ⭐ Foto-Challenges
- ⭐ Like-System
- ⭐ Live-Diashow (Beamer-Modus)
- ⭐ Push-Notifications
- ⭐ Video-Upload
- ⭐ ZIP-Download aller Fotos
- ⭐ Gästebuch
- ⭐ Offline-Queue

### Bewusst NICHT:
- ❌ App Store Release (zu aufwendig, TestFlight reicht)
- ❌ User Accounts (zu kompliziert für Gäste)
- ❌ Chat-Funktion (WhatsApp existiert)
- ❌ Eigenes Backend (Firebase reicht)

---

## 11. Technische Notizen

### Swift/SwiftUI Packages die du brauchst:
- `FirebaseFirestore` – Datenbank
- `FirebaseStorage` – Bild-Upload
- `FirebaseAuth` – Anonyme Auth
- `SDWebImageSwiftUI` oder `Kingfisher` – Async Image Loading
- `CodeScanner` (twostraws) – QR-Code Scanner

### Webseite Dependencies:
- Firebase JS SDK
- `lightgallery.js` – Foto-Lightbox
- `jszip` – ZIP-Download
- Google Fonts: Great Vibes, Lato

### Bildverarbeitung:
- Client-seitig: Thumbnails erzeugen vor Upload (z.B. 300px)
- Oder: Firebase Cloud Function für serverseitige Thumbnail-Generierung
- EXIF-Daten behalten (Zeitstempel!)
- HEIC → JPEG Konvertierung vor Upload

---

## 12. Das Geschenk verpacken

### Idee für die Übergabe:
- Schöne Karte im WeddyBird-Stil
- Darin: Ein QR-Code, der zur App/Webseite führt
- Text: „Für Jasmin & Andreas – damit kein Moment verloren geht. 
  Eure Gäste werden zu Fotografen. Von Onkel Andreas, mit Liebe gebaut."
- Optional: Kleines gerahmtes Foto (8x10) als Platzhalter 
  mit Text „Hier kommt euer Lieblingsfoto von eurer Hochzeit hin"

---

*Erstellt am 21. Februar 2026 · 83 Tage bis zur Hochzeit*
*Projekt: B.I.N.D.A. × HochzeitsSnap*
