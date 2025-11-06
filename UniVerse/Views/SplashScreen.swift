import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "graduation.cap.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text("UniVerse")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
    }
}

#Preview {
    SplashScreen()
}
