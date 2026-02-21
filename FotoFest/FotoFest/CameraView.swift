//
//  CameraView.swift
//  FotoFest
//
//  Foto aufnehmen oder aus Bibliothek wählen, optional Challenge zuordnen,
//  dann hochladen zu Firebase Storage.
//

import SwiftUI

struct CameraView: View {
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebase
    @Environment(\.dismiss) private var dismiss

    var preselectedChallenge: FFChallenge?

    @State private var capturedImage: UIImage?
    @State private var selectedChallenge: FFChallenge?
    @State private var showCamera = false
    @State private var showLibrary = false
    @State private var isUploading = false
    @State private var uploadProgress: String?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ivory.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Vorschau oder Platzhalter
                        photoPreview

                        // Buttons: Kamera / Bibliothek
                        if capturedImage == nil {
                            sourceButtons
                        }

                        // Challenge-Auswahl
                        if capturedImage != nil {
                            challengePicker
                        }

                        // Upload-Button
                        if capturedImage != nil {
                            uploadButton
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Foto aufnehmen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ivory, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                        .foregroundColor(.dustyRose)
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraPickerView(image: $capturedImage)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $showLibrary) {
                LibraryPickerView(image: $capturedImage)
            }
            .alert("Fehler", isPresented: $showError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
            .alert("Hochgeladen!", isPresented: $showSuccess) {
                Button("Super!") { dismiss() }
            } message: {
                Text("Dein Foto ist jetzt in der Galerie sichtbar.")
            }
            .onAppear {
                selectedChallenge = preselectedChallenge
            }
        }
    }

    // MARK: - Subviews

    private var photoPreview: some View {
        Group {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .cornerRadius(16)
                    .shadow(color: .dustyRose.opacity(0.2), radius: 8, y: 4)
                    .overlay(alignment: .topTrailing) {
                        Button {
                            capturedImage = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white, Color.darkBrown.opacity(0.6))
                        }
                        .padding(8)
                    }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.softPink)

                    Text("Wähle eine Quelle")
                        .font(.headline)
                        .foregroundColor(.darkBrown)

                    Text("Mach ein neues Foto oder wähle\neins aus deiner Bibliothek.")
                        .font(.subheadline)
                        .foregroundColor(.darkBrown.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .background(Color.softPink.opacity(0.15))
                .cornerRadius(16)
            }
        }
    }

    private var sourceButtons: some View {
        HStack(spacing: 16) {
            Button {
                showCamera = true
            } label: {
                Label("Kamera", systemImage: "camera.fill")
                    .font(.body.weight(.medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.dustyRose)
                    .cornerRadius(12)
            }

            Button {
                showLibrary = true
            } label: {
                Label("Bibliothek", systemImage: "photo.on.rectangle")
                    .font(.body.weight(.medium))
                    .foregroundColor(.dustyRose)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.dustyRose.opacity(0.12))
                    .cornerRadius(12)
            }
        }
    }

    private var challengePicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Challenge zuordnen (optional)")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.darkBrown)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // "Keine" Option
                    challengeChip(title: "Keine", icon: "xmark", isSelected: selectedChallenge == nil) {
                        selectedChallenge = nil
                    }

                    ForEach(firebase.challenges) { challenge in
                        challengeChip(
                            title: challenge.title,
                            icon: challenge.iconName,
                            isSelected: selectedChallenge?.id == challenge.id
                        ) {
                            selectedChallenge = challenge
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    private func challengeChip(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.dustyRose : Color.dustyRose.opacity(0.1))
            .foregroundColor(isSelected ? .white : .darkBrown)
            .cornerRadius(20)
        }
    }

    private var uploadButton: some View {
        Button {
            Task { await upload() }
        } label: {
            HStack {
                if isUploading {
                    ProgressView()
                        .tint(.white)
                    Text(uploadProgress ?? "Lädt hoch…")
                } else {
                    Image(systemName: "arrow.up.circle.fill")
                    Text("Foto hochladen")
                }
            }
            .font(.body.weight(.medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isUploading ? Color.dustyRose.opacity(0.6) : Color.dustyRose)
            .cornerRadius(14)
        }
        .disabled(isUploading)
    }

    // MARK: - Upload

    private func upload() async {
        guard let image = capturedImage,
              let userId = appState.userId else { return }

        isUploading = true
        uploadProgress = "Wird komprimiert…"

        do {
            uploadProgress = "Wird hochgeladen…"
            let photo = try await firebase.uploadPhoto(
                image: image,
                guestName: appState.guestName,
                userId: userId,
                challengeId: selectedChallenge?.id
            )

            // Challenge als erledigt markieren
            if let challengeId = selectedChallenge?.id {
                try? await firebase.completeChallenge(challengeId: challengeId, userId: userId)
            }

            isUploading = false
            showSuccess = true
        } catch {
            isUploading = false
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

#Preview {
    CameraView()
        .environment(AppState())
        .environment(FirebaseService())
}
