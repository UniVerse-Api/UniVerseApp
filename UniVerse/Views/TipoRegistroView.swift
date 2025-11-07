// Views/SeleccionTipoRegistroView.swift
import SwiftUI

struct SeleccionTipoRegistroView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Fondo oscuro
            Color.backgroundDark
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Card de selección
                VStack(spacing: 24) {
                    // Título
                    Text("¿Cómo quieres\nregistrarte?")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 32)
                    
                    // Botones de selección
                    VStack(spacing: 12) {
                        NavigationLink(destination: RegistroEmpresaView().environmentObject(authVM)) {
                            Text("Empresa")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.primaryOrange)
                                .cornerRadius(8)
                        }
                        
                        NavigationLink(destination: RegistroUniversidadView().environmentObject(authVM)) {
                            Text("Universidad")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.primaryOrange)
                                .cornerRadius(8)
                        }
                        
                        NavigationLink(destination: RegistroEstudianteView().environmentObject(authVM)) {
                            Text("Estudiante")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.primaryOrange)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Link para iniciar sesión
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Text("¿Ya tienes cuenta?")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                            
                            Text("¡Vive la Ronda Social!")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.primaryOrange)
                        }
                    }
                    .padding(.bottom, 32)
                }
                .background(Color.cardBackground)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        SeleccionTipoRegistroView()
            .environmentObject(AuthViewModel())
    }
}
