// App.swift
@main
struct UniVerseApp: App {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authVM.isLoading {
                ProgressView("Cargando...")
            } else {
                if authVM.isAuthenticated {
                    FeedView()
                        .environmentObject(authVM)
                } else {
                    AuthView()
                        .environmentObject(authVM)
                }
            }
        }
    }
}