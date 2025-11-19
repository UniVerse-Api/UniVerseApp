//
//  NavbarEstudianteView.swift
//  
//
//  Created on 18/11/2025.
//

import SwiftUI

struct NavbarEstudianteView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Contenido de las vistas
            TabView(selection: $selectedTab) {
                FeedView()
                    .tag(0)
                
                RedEstudianteView()
                    .tag(1)
                
                EmpleosEstudianteView()
                    .tag(2)
                
                MiPerfilView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Navbar
            HStack(spacing: 0) {
                // Home Button
                NavbarButton(
                    icon: "house.fill",
                    title: "Home",
                    isSelected: selectedTab == 0
                ) {
                    selectedTab = 0
                }
                
                Spacer()
                
                // Network Button
                NavbarButton(
                    icon: "person.2.fill",
                    title: "Network",
                    isSelected: selectedTab == 1
                ) {
                    selectedTab = 1
                }
                
                Spacer()
                
                // Jobs Button
                NavbarButton(
                    icon: "briefcase.fill",
                    title: "Jobs",
                    isSelected: selectedTab == 2
                ) {
                    selectedTab = 2
                }
                
                Spacer()
                
                // Profile Button
                NavbarButton(
                    icon: "person.circle.fill",
                    title: "Profile",
                    isSelected: selectedTab == 3
                ) {
                    selectedTab = 3
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 64)
            .background(
                Color.cardBackground
                    .opacity(0.95)
                    .blur(radius: 2)
            )
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color.borderColor),
                alignment: .top
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct NavbarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                
                Text(title)
                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
            }
        }
    }
}

// MARK: - Preview
struct NavbarEstudianteView_Previews: PreviewProvider {
    static var previews: some View {
        NavbarEstudianteView()
            .environmentObject(AuthViewModel())
            .background(Color.backgroundLight)
    }
}
