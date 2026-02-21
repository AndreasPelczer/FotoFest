//
//  AppState.swift
//  FotoFest
//
//  Zentraler App-Zustand – verwaltet Auth, Event-Daten und Navigation.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@Observable
final class AppState {
    // MARK: - State

    var isLoggedIn = false
    var isLoading = false
    var errorMessage: String?

    var currentEvent: FFEvent?
    var currentGuest: FFGuest?
    var guestName = ""
    var eventCode = ""

    /// Firestore-Pfad zum aktuellen Event (z.B. "events/jasmin-andreas-1605")
    var eventDocumentPath: String? {
        guard let eventId = currentEvent?.id else { return nil }
        return "events/\(eventId)"
    }

    /// Aktueller Firebase Auth User-ID
    var userId: String? {
        Auth.auth().currentUser?.uid
    }

    // MARK: - Join Event

    func joinEvent(code: String, name: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // 1. Anonym anmelden
            let authResult = try await Auth.auth().signInAnonymously()
            let uid = authResult.user.uid

            // 2. Event per eventCode suchen
            let db = Firestore.firestore()
            let snapshot = try await db.collection("events")
                .whereField("eventCode", isEqualTo: code.lowercased())
                .limit(to: 1)
                .getDocuments()

            guard let eventDoc = snapshot.documents.first else {
                isLoading = false
                errorMessage = "Ungültiger Event-Code"
                return
            }

            let event = try eventDoc.data(as: FFEvent.self)
            currentEvent = event

            // 3. Gast registrieren / aktualisieren
            let guest = FFGuest(
                name: name,
                deviceId: UIDevice.current.identifierForVendor?.uuidString ?? uid
            )

            try eventDoc.reference
                .collection("guests")
                .document(uid)
                .setData(from: guest, merge: true)

            currentGuest = guest
            guestName = name
            eventCode = code

            withAnimation(.easeInOut) {
                isLoggedIn = true
            }
        } catch {
            errorMessage = "Verbindungsfehler: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Sign Out

    func signOut() {
        try? Auth.auth().signOut()
        withAnimation(.easeInOut) {
            isLoggedIn = false
        }
        currentEvent = nil
        currentGuest = nil
        guestName = ""
        eventCode = ""
    }
}
