//
//  SettingsView.swift
//  FotoFest
//
//  Mehr-Tab: Gastname, Info, Downloads
//

import SwiftUI

struct SettingsView: View {
    let guestName: String

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ivory.ignoresSafeArea()

                List {
                    Section {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.dustyRose)
                            VStack(alignment: .leading) {
                                Text(guestName)
                                    .font(.headline)
                                    .foregroundColor(.darkBrown)
                                Text("Gast")
                                    .font(.caption)
                                    .foregroundColor(.darkBrown.opacity(0.6))
                            }
                        }
                        .listRowBackground(Color.white)
                    }

                    Section("Event") {
                        Label("Jasmin & Andreas", systemImage: "heart.fill")
                            .foregroundColor(.darkBrown)
                        Label("16. Mai 2026", systemImage: "calendar")
                            .foregroundColor(.darkBrown)
                        Label("Event-Code: jasmin1605", systemImage: "key.fill")
                            .foregroundColor(.darkBrown)
                    }
                    .listRowBackground(Color.white)

                    Section("Info") {
                        Label("Version 1.0", systemImage: "info.circle")
                            .foregroundColor(.darkBrown)
                        Label("Mit Liebe gebaut von Onkel Andreas", systemImage: "heart.circle")
                            .foregroundColor(.darkBrown)
                    }
                    .listRowBackground(Color.white)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Mehr")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ivory, for: .navigationBar)
        }
    }
}

#Preview {
    SettingsView(guestName: "Andreas")
}
