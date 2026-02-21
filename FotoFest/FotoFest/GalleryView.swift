//
//  GalleryView.swift
//  FotoFest
//
//  Foto-Galerie – zeigt alle hochgeladenen Fotos.
//  Wird später mit Firebase Storage + Firestore Listener befüllt.
//

import SwiftUI

struct GalleryView: View {
    let guestName: String
    @State private var photos: [Photo] = []

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ivory.ignoresSafeArea()

                if photos.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(photos) { photo in
                                PhotoThumbnail(photo: photo)
                            }
                        }
                    }
                }

                // Floating Action Button – Kamera
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: openCamera) {
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

    private func openCamera() {
        // TODO: Kamera-Integration + Upload
    }
}

// MARK: - Thumbnail

struct PhotoThumbnail: View {
    let photo: Photo

    var body: some View {
        Rectangle()
            .fill(Color.softPink.opacity(0.3))
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                // Platzhalter – wird durch AsyncImage/Kingfisher ersetzt
                Image(systemName: "photo")
                    .foregroundColor(.dustyRose)
            }
    }
}

#Preview {
    GalleryView(guestName: "Andreas")
}
