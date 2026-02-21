//
//  WelcomeView.swift
//  FotoFest
//
//  Login-Screen: Event-Code + Gastname eingeben
//

import SwiftUI

struct WelcomeView: View {
    @State private var eventCode = ""
    @State private var guestName = ""
    @State private var isLoggedIn = false
    @State private var showError = false

    private let validEventCode = "jasmin1605"

    var body: some View {
        if isLoggedIn {
            MainTabView(guestName: guestName)
        } else {
            loginContent
        }
    }

    private var loginContent: some View {
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

                    if showError {
                        Text("Ungültiger Event-Code")
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    // Login-Button
                    Button("Eintreten") {
                        login()
                    }
                    .buttonStyle(.dustyRose)
                    .disabled(eventCode.isEmpty || guestName.isEmpty)
                    .opacity(eventCode.isEmpty || guestName.isEmpty ? 0.5 : 1.0)

                    Spacer()
                }
            }
        }
    }

    private func login() {
        if eventCode.lowercased() == validEventCode {
            withAnimation {
                isLoggedIn = true
            }
        } else {
            showError = true
        }
    }
}

#Preview {
    WelcomeView()
}
