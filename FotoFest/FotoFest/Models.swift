//
//  Models.swift
//  FotoFest
//
//  Datenmodell – bildet die Firestore-Dokumentstruktur 1:1 ab.
//  Nutzt @DocumentID aus FirebaseFirestore für automatisches ID-Mapping.
//

import Foundation
import FirebaseFirestore

// MARK: - Event

struct FFEvent: Identifiable, Codable {
    @DocumentID var id: String?
    var eventCode: String
    var name: String
    var date: String                  // ISO-8601 String aus Firestore
    var primaryColor: String?
    var accentColor: String?
}

// MARK: - Photo

struct FFPhoto: Identifiable, Codable {
    @DocumentID var id: String?
    var uploadedBy: String            // Auth UID
    var guestName: String?
    var timestamp: Date
    var storageURL: String
    var thumbnailURL: String?
    var originalFilename: String?
    var sizeBytes: Int?
    var challenge: String?
    var likes: Int = 0
    var isVideo: Bool = false
}

// MARK: - Challenge

struct FFChallenge: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var iconName: String              // SF Symbol Name (Firestore-Feldname)
    var completedBy: [String] = []
}

// MARK: - TimelineEntry

struct FFTimelineEntry: Identifiable, Codable {
    @DocumentID var id: String?
    var time: String                  // z.B. "13:00"
    var title: String
    var iconName: String              // SF Symbol Name (Firestore: "iconName")
    var isHighlighted: Bool = false   // Firestore: "isHighlighted"
    var sortOrder: Int = 0            // Firestore: "sortOrder"
}

// MARK: - Guest

struct FFGuest: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var deviceId: String
    var photoCount: Int = 0
}
