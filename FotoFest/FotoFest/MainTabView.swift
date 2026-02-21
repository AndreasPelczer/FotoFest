//
//  MainTabView.swift
//  FotoFest
//
//  Haupt-Navigation mit 4 Tabs: Galerie, Challenges, Ablauf, Mehr
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            GalleryView()
                .tabItem {
                    Label("Galerie", systemImage: "photo.on.rectangle.angled")
                }

            ChallengesView()
                .tabItem {
                    Label("Challenges", systemImage: "target")
                }

            ScheduleView()
                .tabItem {
                    Label("Ablauf", systemImage: "clock")
                }

            SettingsView()
                .tabItem {
                    Label("Mehr", systemImage: "ellipsis")
                }
        }
        .tint(.dustyRose)
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
        .environment(FirebaseService())
}
