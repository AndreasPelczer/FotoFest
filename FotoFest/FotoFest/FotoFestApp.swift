//
//  FotoFestApp.swift
//  FotoFest
//
//  Created by Andreas Pelczer on 21.02.26.
//

import SwiftUI
import FirebaseCore

// MARK: - Firebase App Delegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

// MARK: - App Entry Point

@main
struct FotoFestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var appState = AppState()
    @State private var firebaseService = FirebaseService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(firebaseService)
        }
    }
}

// MARK: - Root View

struct RootView: View {
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebase

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainTabView()
                    .onAppear {
                        if let path = appState.eventDocumentPath {
                            firebase.configure(eventPath: path)
                        }
                    }
            } else {
                WelcomeView()
            }
        }
    }
}
