//
//  PhotoDetailView.swift
//  FotoFest
//
//  Vollbild-Anzeige eines Fotos mit Like, Download und Share.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: FFPhoto

    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebase
    @Environment(\.dismiss) private var dismiss

    @State private var liked = false
    @State private var likeCount: Int
    @State private var showShareSheet = false
    @State private var loadedImage: UIImage?
    @State private var isLoadingImage = false

    init(photo: FFPhoto) {
        self.photo = photo
        _likeCount = State(initialValue: photo.likes)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Foto
            if let url = URL(string: photo.storageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea()
                    case .failure:
                        errorPlaceholder
                    case .empty:
                        ProgressView()
                            .tint(.white)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            // Overlay-Controls oben
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }

                    Spacer()

                    if let name = photo.guestName {
                        Text(name)
                            .font(.caption.weight(.medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                    }
                }
                .padding()

                Spacer()

                // Aktionsleiste unten
                HStack(spacing: 32) {
                    // Like
                    Button { toggleLike() } label: {
                        VStack(spacing: 4) {
                            Image(systemName: liked ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(liked ? .red : .white)
                            Text("\(likeCount)")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }

                    // Download / Teilen
                    Button { sharePhoto() } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Teilen")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }

                    // In Fotos speichern
                    Button { saveToLibrary() } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "arrow.down.to.line")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Speichern")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = loadedImage {
                ShareSheet(items: [image])
            }
        }
    }

    // MARK: - Subviews

    private var errorPlaceholder: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("Foto konnte nicht geladen werden")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    // MARK: - Actions

    private func toggleLike() {
        guard let photoId = photo.id,
              let userId = appState.userId else { return }

        liked.toggle()
        likeCount += liked ? 1 : -1

        Task {
            try? await firebase.toggleLike(photoId: photoId, userId: userId)
        }
    }

    private func sharePhoto() {
        Task {
            let image = await downloadImage()
            if let image {
                loadedImage = image
                showShareSheet = true
            }
        }
    }

    private func saveToLibrary() {
        Task {
            let image = await downloadImage()
            if let image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }

    private func downloadImage() async -> UIImage? {
        guard let url = URL(string: photo.storageURL) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}

// MARK: - ShareSheet (UIKit Bridge)

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
