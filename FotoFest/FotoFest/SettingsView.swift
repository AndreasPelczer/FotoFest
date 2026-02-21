//
//  SettingsView.swift
//  FotoFest
//
//  Mehr-Tab: Gastprofil, Event-Info, Abmelden
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebase
    @State private var showSignOutConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ivory.ignoresSafeArea()

                List {
                    // Gast-Profil
                    Section {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.dustyRose)
                            VStack(alignment: .leading) {
                                Text(appState.guestName)
                                    .font(.headline)
                                    .foregroundColor(.darkBrown)
                                Text("Gast")
                                    .font(.caption)
                                    .foregroundColor(.darkBrown.opacity(0.6))
                            }
                        }
                        .listRowBackground(Color.white)
                    }

                    // Event-Infos (aus Firestore)
                    Section("Event") {
                        if let event = appState.currentEvent {
                            Label(event.name, systemImage: "heart.fill")
                                .foregroundColor(.darkBrown)
                            Label(formatDate(event.date), systemImage: "calendar")
                                .foregroundColor(.darkBrown)
                        }
                        Label("Event-Code: \(appState.eventCode)", systemImage: "key.fill")
                            .foregroundColor(.darkBrown)
                    }
                    .listRowBackground(Color.white)

                    // Statistiken
                    Section("Statistiken") {
                        Label("\(firebase.photos.count) Fotos insgesamt", systemImage: "photo.fill")
                            .foregroundColor(.darkBrown)
                        Label(
                            "\(firebase.photos.filter { $0.uploadedBy == appState.userId }.count) eigene Fotos",
                            systemImage: "camera.fill"
                        )
                        .foregroundColor(.darkBrown)
                    }
                    .listRowBackground(Color.white)

                    // Info
                    Section("Info") {
                        Label("Version 1.0", systemImage: "info.circle")
                            .foregroundColor(.darkBrown)
                        Label("Mit Liebe gebaut von Onkel Andreas", systemImage: "heart.circle")
                            .foregroundColor(.darkBrown)
                    }
                    .listRowBackground(Color.white)

                    // Abmelden
                    Section {
                        Button(role: .destructive) {
                            showSignOutConfirmation = true
                        } label: {
                            Label("Abmelden", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                        .listRowBackground(Color.white)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Mehr")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ivory, for: .navigationBar)
            .alert("Abmelden?", isPresented: $showSignOutConfirmation) {
                Button("Abmelden", role: .destructive) {
                    firebase.stopAll()
                    appState.signOut()
                }
                Button("Abbrechen", role: .cancel) {}
            } message: {
                Text("Du kannst dich jederzeit mit dem Event-Code wieder anmelden.")
            }
        }
    }

    private func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime, .withTimeZone]
        if let date = formatter.date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.locale = Locale(identifier: "de_DE")
            displayFormatter.dateStyle = .long
            return displayFormatter.string(from: date)
        }
        return isoString
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
        .environment(FirebaseService())
}
