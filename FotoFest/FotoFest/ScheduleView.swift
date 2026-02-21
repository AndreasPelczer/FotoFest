//
//  ScheduleView.swift
//  FotoFest
//
//  Tagesablauf aus Firestore – Nachbildung der WeddyBird-Timeline.
//  (Umbenannt von TimelineView, um Namenskollision mit SwiftUI zu vermeiden.)
//

import SwiftUI

struct ScheduleView: View {
    @Environment(FirebaseService.self) private var firebase

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ivory.ignoresSafeArea()

                if firebase.timeline.isEmpty {
                    ProgressView("Ablauf laden…")
                        .tint(.dustyRose)
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(firebase.timeline.enumerated()), id: \.element.id) { index, entry in
                                ScheduleRow(entry: entry, isLast: index == firebase.timeline.count - 1)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Ablauf")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ivory, for: .navigationBar)
        }
    }
}

// MARK: - Row

struct ScheduleRow: View {
    let entry: FFTimelineEntry
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Zeitachse (Linie + Punkt)
            VStack(spacing: 0) {
                Circle()
                    .fill(entry.isHighlighted ? Color.dustyRose : Color.softPink)
                    .frame(width: 14, height: 14)
                    .overlay {
                        if entry.isHighlighted {
                            Circle()
                                .stroke(Color.dustyRose.opacity(0.3), lineWidth: 4)
                                .frame(width: 22, height: 22)
                        }
                    }

                if !isLast {
                    Rectangle()
                        .fill(Color.softPink)
                        .frame(width: 2, height: 60)
                }
            }

            // Icon
            Image(systemName: entry.iconName)
                .font(.body)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(entry.isHighlighted ? Color.dustyRose : Color.softPink)
                .clipShape(Circle())

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.time)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.dustyRose)

                Text(entry.title)
                    .font(.body)
                    .foregroundColor(.darkBrown)
                    .fontWeight(entry.isHighlighted ? .semibold : .regular)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ScheduleView()
        .environment(FirebaseService())
}
