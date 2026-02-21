//
//  Models.swift
//  FotoFest
//
//  Datenmodell – bildet die Firestore-Dokumentstruktur ab.
//  Wird später mit FirebaseFirestoreSwift (@DocumentID, Codable) erweitert.
//

import Foundation

// MARK: - Photo

struct Photo: Identifiable, Codable {
    var id: String = UUID().uuidString
    var uploadedBy: String
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

struct Challenge: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var icon: String              // SF Symbol Name
    var completedBy: [String] = []
}

// MARK: - TimelineEntry

struct TimelineEntry: Identifiable, Codable {
    var id: String = UUID().uuidString
    var time: String              // z.B. "13:00"
    var title: String
    var icon: String              // SF Symbol Name
    var isActive: Bool = false
}

// MARK: - Guest

struct Guest: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var deviceId: String
    var photoCount: Int = 0
}

// MARK: - Event

struct Event: Identifiable, Codable {
    var id: String = UUID().uuidString
    var eventCode: String
    var eventDate: Date
    var eventName: String
}
