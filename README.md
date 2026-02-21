# FotoFest 📸

**Hochzeits-Foto-App für Jasmin & Andreas · 16. Mai 2026**

Eine native iOS-App + Begleit-Webseite, mit der Gäste ihre Fotos in Echtzeit in einer gemeinsamen Galerie teilen – in Originalqualität, ohne WhatsApp-Komprimierung.

## Status

| Komponente | Status |
|---|---|
| Firebase Backend | ✅ Live (Firestore, Storage, Auth, Hosting) |
| Webseite | ✅ Live → [meineapp-99d5b.web.app](https://meineapp-99d5b.web.app) |
| Datenbank | ✅ Befüllt (Event, Timeline, Challenges) |
| iOS-App UI | 🔧 Grundstruktur vorhanden, Firebase-Anbindung offen |
| TestFlight | ⏳ Geplant bis 2. Mai |

## Features

- **Gemeinsame Foto-Galerie** – Echtzeit-Updates via Firestore
- **8 Foto-Challenges** – Selfie mit Brautpaar, bestes Essen, lustigster Moment...
- **Tagesablauf** – Live-Timeline von 13:00 bis 00:00
- **QR-Code-Zugang** – Kein Account nötig, Event-Code `jasmin1605`
- **Web-Fallback** – Upload + Galerie für Android-Gäste

## Tech Stack

| | Technologie |
|---|---|
| **iOS** | Swift 5.9+, SwiftUI, iOS 17+ |
| **Backend** | Firebase (Firestore, Storage, Auth) |
| **Webseite** | HTML/CSS/JS + Firebase JS SDK |
| **Fonts** | Great Vibes (Display), Nunito (Web), System Rounded (iOS) |
| **Distribution** | TestFlight |

## Projektstruktur

```
FotoFest/
├── App/
│   ├── FotoFestApp.swift           # Entry Point + AppState
│   └── MainTabView.swift           # Tab Bar + Floating Camera
├── Core/
│   ├── Design/DesignSystem.swift   # Farben, Typo, Buttons, Cards
│   └── Models/Models.swift         # Datenmodelle + Demo-Daten
└── Features/
    ├── Welcome/                    # Login + QR-Scanner
    ├── Gallery/                    # Foto-Grid
    ├── Camera/                     # Kamera + Upload
    ├── Challenges/                 # Foto-Aufgaben
    ├── Timeline/                   # Tagesablauf
    ├── PhotoDetail/                # Vollbild-Ansicht
    └── Settings/                   # Profil + Info
```

## Firebase

| Service | Projekt-ID | Region |
|---|---|---|
| Firestore | `meineapp-99d5b` | europe-west3 |
| Storage | `meineapp-99d5b.appspot.com` | europe-west3 |
| Hosting | `meineapp-99d5b.web.app` | – |
| Auth | Anonym + E-Mail/Passwort | – |
| Bundle-ID (iOS) | `io.imops.FotoFest` | – |

## Design System

Farbpalette extrahiert aus der Hochzeitswebsite ([WeddyBird](https://jasmin-andreas-1605.weddybird.com)):

| Farbe | Hex | Verwendung |
|---|---|---|
| Dusty Rose | `#C9A0A0` | Primärakzent, Buttons |
| Rose Soft | `#E8C4C4` | Hintergrund-Akzent, Icon-Kreise |
| Peach | `#D9A08E` | Sekundärakzent |
| Sage | `#8A9A7E` | Erfolg, Tertiärakzent |
| Cream | `#FAF7F4` | Seitenhintergrund |
| Text Primary | `#3C2A2A` | Überschriften |

## Setup

### iOS-App
1. Repo klonen
2. `GoogleService-Info.plist` in `FotoFest/Resources/` legen (beim Owner anfragen)
3. [Great Vibes](https://fonts.google.com/specimen/Great+Vibes) Font herunterladen → `Resources/`
4. In Xcode: SPM Packages hinzufügen (`firebase-ios-sdk`)
5. `Cmd+R`

### Webseite
```bash
cd fotofest-web
firebase deploy
```

## Zeitplan

| Phase | Bis | Was |
|---|---|---|
| ~~Phase 1~~ | ~~7. März~~ | ✅ Firebase, Projektstruktur, Design System, Webseite |
| Phase 2 | 28. März | Kamera, Upload, Live-Galerie, Challenges |
| Phase 3 | 18. April | Polish, Thumbnails, Animations |
| Phase 4 | 2. Mai | TestFlight, Beta-Test |
| Phase 5 | 16. Mai | 🎉 **Hochzeitstag** |

## Dokumentation

- [`DEVELOPER_BRIEFING.md`](DEVELOPER_BRIEFING.md) – Technisches Briefing für Entwickler
- Firebase Console: [console.firebase.google.com/project/meineapp-99d5b](https://console.firebase.google.com/project/meineapp-99d5b)

---

*B.I.N.D.A. · FotoFest · 2026*
