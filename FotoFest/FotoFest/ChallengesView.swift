//
//  ChallengesView.swift
//  FotoFest
//
//  Foto-Challenges aus Firestore – Aufgaben für die Gäste
//

import SwiftUI

struct ChallengesView: View {
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebase
    @State private var showCamera = false
    @State private var selectedChallenge: FFChallenge?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ivory.ignoresSafeArea()

                if firebase.challenges.isEmpty {
                    ProgressView("Challenges laden…")
                        .tint(.dustyRose)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(firebase.challenges) { challenge in
                                ChallengeRow(
                                    challenge: challenge,
                                    userId: appState.userId
                                ) {
                                    selectedChallenge = challenge
                                    showCamera = true
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ivory, for: .navigationBar)
            .sheet(isPresented: $showCamera) {
                CameraView(preselectedChallenge: selectedChallenge)
            }
        }
    }
}

// MARK: - Row

struct ChallengeRow: View {
    let challenge: FFChallenge
    let userId: String?
    let onCapture: () -> Void

    var isCompletedByMe: Bool {
        guard let userId else { return false }
        return challenge.completedBy.contains(userId)
    }

    var completionCount: Int {
        challenge.completedBy.count
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: challenge.iconName)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(isCompletedByMe ? Color.sageDarkGreen : Color.dustyRose)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(challenge.title)
                    .font(.body)
                    .foregroundColor(.darkBrown)

                if completionCount > 0 {
                    Text("\(completionCount)× erledigt")
                        .font(.caption)
                        .foregroundColor(.sageDarkGreen)
                }
            }

            Spacer()

            if isCompletedByMe {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.sageDarkGreen)
            } else {
                Button { onCapture() } label: {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.dustyRose)
                        .frame(width: 36, height: 36)
                        .background(Color.dustyRose.opacity(0.12))
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    ChallengesView()
        .environment(AppState())
        .environment(FirebaseService())
}
