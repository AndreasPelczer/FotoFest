//
//  FirebaseService.swift
//  FotoFest
//
//  Service-Layer für alle Firebase-Operationen:
//  Firestore-Listener, Storage-Upload, Foto-Management.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import UIKit

@Observable
final class FirebaseService {
    private lazy var db = Firestore.firestore()
    private lazy var storage = Storage.storage()

    // MARK: - Cached Data

    var photos: [FFPhoto] = []
    var challenges: [FFChallenge] = []
    var timeline: [FFTimelineEntry] = []

    // Listener-Registrierungen
    private var photosListener: ListenerRegistration?
    private var challengesListener: ListenerRegistration?
    private var timelineListener: ListenerRegistration?

    // MARK: - Event-Pfad

    private var eventPath: String?

    func configure(eventPath: String) {
        self.eventPath = eventPath
        startListeners()
    }

    func stopAll() {
        photosListener?.remove()
        challengesListener?.remove()
        timelineListener?.remove()
    }

    // MARK: - Echtzeit-Listener

    private func startListeners() {
        guard let eventPath else { return }

        // Photos – sortiert nach timestamp absteigend
        photosListener = db.collection("\(eventPath)/photos")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let docs = snapshot?.documents else { return }
                self?.photos = docs.compactMap { try? $0.data(as: FFPhoto.self) }
            }

        // Challenges – sortiert nach Dokument-ID
        challengesListener = db.collection("\(eventPath)/challenges")
            .order(by: FieldPath.documentID())
            .addSnapshotListener { [weak self] snapshot, error in
                guard let docs = snapshot?.documents else { return }
                self?.challenges = docs.compactMap { try? $0.data(as: FFChallenge.self) }
            }

        // Timeline – sortiert nach time
        timelineListener = db.collection("\(eventPath)/timeline")
            .order(by: "time")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let docs = snapshot?.documents else { return }
                self?.timeline = docs.compactMap { try? $0.data(as: FFTimelineEntry.self) }
            }
    }

    // MARK: - Foto hochladen

    func uploadPhoto(
        image: UIImage,
        guestName: String,
        userId: String,
        challengeId: String? = nil
    ) async throws -> FFPhoto {
        guard let eventPath else {
            throw FirebaseServiceError.notConfigured
        }

        // 1. JPEG-Komprimierung
        guard let fullData = image.jpegData(compressionQuality: 0.8) else {
            throw FirebaseServiceError.imageConversionFailed
        }

        // 2. Thumbnail erstellen (300px Breite)
        let thumbnailImage = createThumbnail(from: image, maxWidth: 300)
        let thumbData = thumbnailImage.jpegData(compressionQuality: 0.6)

        // 3. Dateinamen generieren
        let timestamp = Date()
        let filename = "\(Int(timestamp.timeIntervalSince1970))_\(UUID().uuidString.prefix(8)).jpg"
        let storagePath = "\(eventPath)/photos/\(filename)"
        let thumbPath = "\(eventPath)/thumbnails/\(filename)"

        // 4. Vollbild hochladen
        let fullRef = storage.reference().child(storagePath)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await fullRef.putDataAsync(fullData, metadata: metadata)
        let fullURL = try await fullRef.downloadURL()

        // 5. Thumbnail hochladen
        var thumbURL: URL?
        if let thumbData {
            let thumbRef = storage.reference().child(thumbPath)
            _ = try await thumbRef.putDataAsync(thumbData, metadata: metadata)
            thumbURL = try await thumbRef.downloadURL()
        }

        // 6. Firestore-Dokument erstellen
        let photo = FFPhoto(
            uploadedBy: userId,
            guestName: guestName,
            timestamp: timestamp,
            storageURL: fullURL.absoluteString,
            thumbnailURL: thumbURL?.absoluteString,
            originalFilename: filename,
            sizeBytes: fullData.count,
            challenge: challengeId
        )

        try db.collection("\(eventPath)/photos")
            .addDocument(from: photo)

        // 7. Foto-Zähler beim Gast erhöhen
        try await db.collection("\(eventPath)/guests")
            .document(userId)
            .updateData(["photoCount": FieldValue.increment(Int64(1))])

        return photo
    }

    // MARK: - Like

    func toggleLike(photoId: String, userId: String) async throws {
        guard let eventPath else { return }

        let ref = db.collection("\(eventPath)/photos").document(photoId)
        try await ref.updateData([
            "likes": FieldValue.increment(Int64(1))
        ])
    }

    // MARK: - Challenge abschließen

    func completeChallenge(challengeId: String, userId: String) async throws {
        guard let eventPath else { return }

        let ref = db.collection("\(eventPath)/challenges").document(challengeId)
        try await ref.updateData([
            "completedBy": FieldValue.arrayUnion([userId])
        ])
    }

    // MARK: - Helpers

    private func createThumbnail(from image: UIImage, maxWidth: CGFloat) -> UIImage {
        let scale = maxWidth / image.size.width
        let newHeight = image.size.height * scale
        let size = CGSize(width: maxWidth, height: newHeight)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

// MARK: - Errors

enum FirebaseServiceError: LocalizedError {
    case notConfigured
    case imageConversionFailed

    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Firebase Service ist noch nicht konfiguriert."
        case .imageConversionFailed:
            return "Bild konnte nicht konvertiert werden."
        }
    }
}
