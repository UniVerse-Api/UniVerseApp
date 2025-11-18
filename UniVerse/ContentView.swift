import SwiftUI

struct ContentView: View {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if authVM.isLoading {
                    SplashScreen()
                } else {
                    switch authVM.initialView {
                    case .auth:
                        AuthView()
                    case .feed:
                        FeedView()
                    case .studentDashboard:
                        NavbarEstudianteView()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(authVM)
    }
}

#Preview {
    ContentView()
}
