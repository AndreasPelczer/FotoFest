//
//  MainTabView.swift
//  FotoFest
//
//  Haupt-Navigation mit 4 Tabs: Galerie, Challenges, Ablauf, Mehr
//

import SwiftUI

struct MainTabView: View {
    let guestName: String

    var body: some View {
        TabView {
            GalleryView(guestName: guestName)
                .tabItem {
                    Label("Galerie", systemImage: "photo.on.rectangle.angled")
                }

            ChallengesView()
                .tabItem {
                    Label("Challenges", systemImage: "target")
                }

            TimelineView()
                .tabItem {
                    Label("Ablauf", systemImage: "clock")
                }

            SettingsView(guestName: guestName)
                .tabItem {
                    Label("Mehr", systemImage: "ellipsis")
                }
        }
        .tint(.dustyRose)
    }
}

#Preview {
    MainTabView(guestName: "Andreas")
}
