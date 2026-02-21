//
//  GalleryView.swift
//  FotoFest
//
//  Foto-Galerie mit Echtzeit-Firestore-Listener und Kamera-Button.
//

import SwiftUI

struct GalleryView: View {
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebase
    @State private var showCamera = false
    @State private var selectedPhoto: FFPhoto?

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ivory.ignoresSafeArea()

                if firebase.photos.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        // Foto-Statistik
                        HStack {
                            Label("\(firebase.photos.count) Fotos", systemImage: "photo.fill")
                                .font(.caption)
                                .foregroundColor(.darkBrown.opacity(0.6))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(firebase.photos) { photo in
                                PhotoThumbnail(photo: photo)
                                    .onTapGesture {
                                        selectedPhoto = photo
                                    }
                            }
                        }
                    }
                }

                // Floating Action Button – Kamera
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button { showCamera = true } label: {
                            Image(systemName: "camera.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.dustyRose)
                                .clipShape(Circle())
                                .shadow(color: .dustyRose.opacity(0.4), radius: 8, y: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Galerie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ivory, for: .navigationBar)
            .sheet(isPresented: $showCamera) {
                CameraView()
            }
            .fullScreenCover(item: $selectedPhoto) { photo in
                PhotoDetailView(photo: photo)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundColor(.softPink)

            Text("Noch keine Fotos")
                .font(.headline)
                .foregroundColor(.darkBrown)

            Text("Drücke den Kamera-Button\num das erste Foto zu machen!")
                .font(.subheadline)
                .foregroundColor(.darkBrown.opacity(0.6))
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Thumbnail

struct PhotoThumbnail: View {
    let photo: FFPhoto

    var body: some View {
        let url = URL(string: photo.thumbnailURL ?? photo.storageURL)

        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
            case .failure:
                placeholder
            case .empty:
                placeholder
                    .overlay { ProgressView().tint(.dustyRose) }
            @unknown default:
                placeholder
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color.softPink.opacity(0.3))
            .overlay {
                Image(systemName: "photo")
                    .foregroundColor(.dustyRose)
            }
    }
}

#Preview {
    GalleryView()
        .environment(AppState())
        .environment(FirebaseService())
}
