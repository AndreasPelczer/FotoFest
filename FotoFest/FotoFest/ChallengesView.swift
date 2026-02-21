//
//  ChallengesView.swift
//  FotoFest
//
//  Foto-Challenges / Aufgaben für die Gäste
//

import SwiftUI

struct ChallengesView: View {
    @State private var challenges: [Challenge] = Challenge.defaults

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ivory.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(challenges) { challenge in
                            ChallengeRow(challenge: challenge)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ivory, for: .navigationBar)
        }
    }
}

// MARK: - Row

struct ChallengeRow: View {
    let challenge: Challenge

    var isCompleted: Bool {
        !challenge.completedBy.isEmpty
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: challenge.icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(isCompleted ? Color.sageDarkGreen : Color.dustyRose)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(challenge.title)
                    .font(.body)
                    .foregroundColor(.darkBrown)

                if isCompleted {
                    Text("\(challenge.completedBy.count) erledigt")
                        .font(.caption)
                        .foregroundColor(.sageDarkGreen)
                }
            }

            Spacer()

            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.sageDarkGreen)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Default Challenges

extension Challenge {
    static let defaults: [Challenge] = [
        Challenge(title: "Mach ein Selfie mit dem Brautpaar", icon: "person.2.fill"),
        Challenge(title: "Fotografiere den schönsten Blumenstrauß", icon: "camera.macro"),
        Challenge(title: "Fang einen lustigen Moment auf der Tanzfläche ein", icon: "figure.dance"),
        Challenge(title: "Zeig uns dein Outfit", icon: "tshirt.fill"),
        Challenge(title: "Wer hat die verrücktesten Schuhe?", icon: "shoe.fill"),
        Challenge(title: "Fotografiere den ältesten Gast", icon: "person.fill"),
        Challenge(title: "Das beste Essen des Abends", icon: "fork.knife"),
        Challenge(title: "Der schönste Moment der Trauung", icon: "heart.fill"),
    ]
}

#Preview {
    ChallengesView()
}
