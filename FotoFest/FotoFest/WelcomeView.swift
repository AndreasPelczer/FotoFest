//
//  WelcomeView.swift
//  FotoFest
//
//  Login-Screen: Event-Code + Gastname eingeben → Firebase Auth
//

import SwiftUI

struct WelcomeView: View {
    @Environment(AppState.self) private var appState
    @State private var eventCode = ""
    @State private var guestName = ""

    var body: some View {
        ZStack {
            Color.ivory.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    Spacer().frame(height: 60)

                    // Titel
                    VStack(spacing: 8) {
                        Text("Jasmin & Andreas")
                            .font(.system(size: 38, weight: .light, design: .serif))
                            .foregroundColor(.darkBrown)

                        Text("16. Mai 2026")
                            .font(.subheadline)
                            .foregroundColor(.dustyRose)
                            .tracking(2)
                    }

                    // Trennlinie
                    Rectangle()
                        .fill(Color.softPink)
                        .frame(width: 80, height: 1)

                    // Icon
                    Image(systemName: "camera.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(Color.dustyRose)
                        .clipShape(Circle())

                    Text("Haltet eure schönsten\nMomente fest!")
                        .font(.body)
                        .foregroundColor(.darkBrown.opacity(0.7))
                        .multilineTextAlignment(.center)

                    // Eingabefelder
                    VStack(spacing: 16) {
                        TextField("Event-Code", text: $eventCode)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.softPink, lineWidth: 1)
                            )
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                        TextField("Dein Name", text: $guestName)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.softPink, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 40)

                    // Fehler-Anzeige
                    if let error = appState.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .transition(.opacity)
                    }

                    // Login-Button
                    Button {
                        Task {
                            await appState.joinEvent(code: eventCode, name: guestName)
                        }
                    } label: {
                        HStack {
                            if appState.isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text(appState.isLoading ? "Verbinde…" : "Eintreten")
                        }
                    }
                    .buttonStyle(.dustyRose)
                    .disabled(eventCode.isEmpty || guestName.isEmpty || appState.isLoading)
                    .opacity(eventCode.isEmpty || guestName.isEmpty ? 0.5 : 1.0)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environment(AppState())
}
