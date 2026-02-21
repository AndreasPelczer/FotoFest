//
//  TimelineView.swift
//  FotoFest
//
//  Tagesablauf – Nachbildung der WeddyBird-Timeline
//

import SwiftUI

struct TimelineView: View {
    @State private var entries: [TimelineEntry] = TimelineEntry.defaults

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ivory.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                            TimelineRow(entry: entry, isLast: index == entries.count - 1)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Ablauf")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ivory, for: .navigationBar)
        }
    }
}

// MARK: - Row

struct TimelineRow: View {
    let entry: TimelineEntry
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Zeitachse (Linie + Punkt)
            VStack(spacing: 0) {
                Circle()
                    .fill(entry.isActive ? Color.dustyRose : Color.softPink)
                    .frame(width: 14, height: 14)
                    .overlay {
                        if entry.isActive {
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
            Image(systemName: entry.icon)
                .font(.body)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(entry.isActive ? Color.dustyRose : Color.softPink)
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
                    .fontWeight(entry.isActive ? .semibold : .regular)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Default Timeline

extension TimelineEntry {
    static let defaults: [TimelineEntry] = [
        TimelineEntry(time: "13:00", title: "Ankunft der Gäste", icon: "car.fill"),
        TimelineEntry(time: "13:30", title: "Freie Trauung", icon: "heart.fill", isActive: false),
        TimelineEntry(time: "14:30", title: "Sektempfang und Gratulation", icon: "wineglass.fill"),
        TimelineEntry(time: "16:00", title: "Kaffee und Kuchen", icon: "cup.and.saucer.fill"),
        TimelineEntry(time: "18:00", title: "Abendessen", icon: "fork.knife"),
        TimelineEntry(time: "21:00", title: "Hochzeitstanz & Party", icon: "figure.dance"),
        TimelineEntry(time: "00:00", title: "Ende der Feier", icon: "moon.stars.fill"),
    ]
}

#Preview {
    TimelineView()
}
