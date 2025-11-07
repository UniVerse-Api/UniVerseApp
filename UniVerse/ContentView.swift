import SwiftUI

struct ContentView: View {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
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

#Preview {
    ContentView()
}
