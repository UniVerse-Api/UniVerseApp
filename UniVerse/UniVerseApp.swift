// App.swift
import SwiftUI

@main
struct UniVerseApp: App {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isLoading {
                    SplashScreen()  
                } else {
                    switch authVM.initialView {
                    case .auth:
                        AuthView() 
                    case .feed:
                        FeedView()  
                    }
                }
            }
            .environmentObject(authVM)
        }
    }
}