# FotoFest 📸

**Die Event-Foto-App – gebaut mit Liebe für Jasmin & Andreas**

Eine native iOS-App (SwiftUI) + Begleit-Webseite, mit der Hochzeitsgäste ihre Fotos in Echtzeit in einer gemeinsamen Galerie teilen können.

## 🎯 Features

- **Gemeinsame Foto-Galerie** – Alle Gäste sehen alle Fotos in Echtzeit
- **Foto-Challenges** – Lustige Aufgaben bringen Gäste zusammen
- **Tagesablauf** – Live-Timeline mit aktuellem Programmpunkt
- **QR-Code-Zugang** – Kein Account nötig, einfach scannen und mitmachen
- **Originalqualität** – Keine Komprimierung wie bei WhatsApp
- **Web-Fallback** – Für Android-Gäste und Desktop

## 🏗 Architektur

```
FotoFest/
├── App/                    # App Entry Point, Tab Navigation
├── Core/
│   ├── Design/             # Design System (Farben, Typo, Components)
│   ├── Models/             # Datenmodelle (Event, Photo, Challenge...)
│   ├── Services/           # Firebase, Kamera, Storage
│   └── Extensions/         # Swift Extensions
├── Features/
│   ├── Welcome/            # Login / QR-Code Scanner
│   ├── Gallery/            # Foto-Grid mit Echtzeit-Updates
│   ├── Camera/             # Kamera + Upload
│   ├── Challenges/         # Foto-Aufgaben
│   ├── Timeline/           # Tagesablauf
│   ├── PhotoDetail/        # Vollbild-Ansicht
│   └── Settings/           # Profil, Info, Abmelden
└── Resources/              # Assets, Fonts, Config
```

## 🎨 Design System

Farbpalette extrahiert aus der Hochzeitswebsite (WeddyBird):

| Farbe | Hex | Verwendung |
|-------|-----|------------|
| Dusty Rose | `#C9A0A0` | Primärakzent, Buttons |
| Rose Soft | `#E8C4C4` | Hintergrund-Akzent |
| Peach | `#D9A08E` | Sekundärakzent |
| Sage | `#8A9A7E` | Erfolg, Akzent |
| Cream | `#FAF7F4` | Seitenhintergrund |

Font: *Great Vibes* (Google Fonts) für Display, System Rounded für Body.

## 🛠 Tech Stack

- **iOS**: Swift 5.9+, SwiftUI, iOS 17+
- **Backend**: Firebase (Firestore, Storage, Auth)
- **Webseite**: HTML/CSS/JS + Firebase JS SDK
- **Distribution**: TestFlight (bis 10.000 Tester)
- **Packages**:
  - `firebase-ios-sdk`
  - `SDWebImageSwiftUI` (Async Image Loading)
  - `CodeScanner` (QR-Code)

## 🚀 Setup

### 1. Firebase einrichten
1. Neues Firebase-Projekt erstellen
2. iOS-App registrieren (Bundle ID: `de.binda.FotoFest`)
3. `GoogleService-Info.plist` herunterladen → in `Resources/` legen
4. Firestore, Storage und Auth aktivieren

### 2. Xcode
```bash
git clone https://github.com/[dein-username]/FotoFest.git
cd FotoFest
open FotoFest.xcodeproj
```

### 3. Font installieren
1. [Great Vibes](https://fonts.google.com/specimen/Great+Vibes) herunterladen
2. `GreatVibes-Regular.ttf` in `Resources/` legen
3. In Info.plist unter "Fonts provided by application" eintragen

## 📅 Timeline

- **Phase 1** (bis 7. März): Grundstruktur, Firebase, Auth
- **Phase 2** (bis 28. März): Kamera, Galerie, Challenges
- **Phase 3** (bis 18. April): Polish, Webseite, ZIP-Download
- **Phase 4** (bis 2. Mai): TestFlight, Beta-Test
- **Phase 5** (16. Mai): 🎉 Hochzeitstag!

## 📝 Lizenz

Privates Projekt. Erstellt als Geschenk für Jasmin & Andreas.

---

*B.I.N.D.A. · FotoFest · 2026*
