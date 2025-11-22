// Views/Components/ProfileCardView.swift
import SwiftUI

struct ProfileCardView: View {
    let perfil: PerfilRed
    let onFollowToggle: () -> Void
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Profile Image with Premium Effect
            ZStack {
                if perfil.esPremium {
                    // Premium gradient border
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple, .indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 62, height: 62)
                        .blur(radius: 0.5)
                        .opacity(0.8)
                }

                NavigationLink(
                    destination: ProfileDestinationView(
                        idPerfil: perfil.id,
                        nombreCompleto: perfil.nombreCompleto,
                        fotoPerfil: perfil.fotoPerfil,
                        esEmpresa: perfil.tipoPerfil == "empresa"
                    )
                    .environmentObject(authVM)
                ) {
                    AsyncImage(url: URL(string: perfil.fotoPerfil ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color(.systemGray4))
                            .overlay(
                                Text(String(perfil.nombreCompleto.prefix(2)).uppercased())
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                }

                // Premium crown
                if perfil.esPremium {
                    VStack {
                        HStack {
                            Spacer()
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 18, height: 18)
                                .overlay(
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 9))
                                        .foregroundColor(.white)
                                )
                                .shadow(radius: 2)
                                .offset(x: 6, y: -6)
                        }
                        Spacer()
                    }
                    .frame(width: 56, height: 56)
                }
            }

            // Profile Info
            VStack(alignment: .leading, spacing: 4) {
                // Name and badges
                HStack(alignment: .center, spacing: 8) {
                    NavigationLink(
                        destination: ProfileDestinationView(
                            idPerfil: perfil.id,
                            nombreCompleto: perfil.nombreCompleto,
                            fotoPerfil: perfil.fotoPerfil,
                            esEmpresa: perfil.tipoPerfil == "empresa"
                        )
                        .environmentObject(authVM)
                    ) {
                        Text(perfil.nombreCompleto)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                    }

                    // Type badge
                    Text(perfil.tipoPerfil.capitalized)
                        .font(.system(size: 10, weight: .medium))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            perfil.tipoPerfil == "empresa" ?
                            Color.blue.opacity(0.1) : Color.green.opacity(0.1)
                        )
                        .foregroundColor(perfil.tipoPerfil == "empresa" ? .blue : .green)
                        .cornerRadius(4)

                    // Premium badge
                    if perfil.esPremium {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                    }

                    Spacer()
                }

                // Location
                if let ubicacion = perfil.ubicacion, !ubicacion.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)

                        Text(ubicacion)
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                    }
                }

                // Bio (truncated)
                Text(perfil.biografia)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 8)

                // Stats and Follow Button
                HStack {
                    // Stats
                    HStack(spacing: 12) {
                        NetworkStatItem(value: "\(perfil.seguidoresCount)", label: "Seguidores")
                        NetworkStatItem(value: "\(perfil.siguiendoCount)", label: "Siguiendo")
                    }

                    Spacer()

                    // Follow Button
                    Button(action: onFollowToggle) {
                        Text(perfil.sigoAEstePerfil ? "Siguiendo" : "Seguir")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(perfil.sigoAEstePerfil ? .textPrimary : .white)
                            .frame(width: 90, height: 32)
                            .background(
                                perfil.sigoAEstePerfil ?
                                Color.gray.opacity(0.2) :
                                Color.primaryOrange
                            )
                            .cornerRadius(16)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Supporting Views

struct NetworkStatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.textPrimary)

            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.textSecondary)
        }
    }
}

#Preview {
    ProfileCardView(
        perfil: PerfilRed(
            id: 1,
            nombreCompleto: "Juan Pérez",
            fotoPerfil: nil,
            biografia: "Estudiante de Ingeniería Informática apasionado por el desarrollo móvil y la inteligencia artificial.",
            tipoPerfil: "estudiante",
            ubicacion: "San Salvador, El Salvador",
            pais: "El Salvador",
            esPremium: true,
            sigoAEstePerfil: false,
            seguidoresCount: 45,
            siguiendoCount: 32
        ),
        onFollowToggle: {}
    )
    .padding()
    .environmentObject(AuthViewModel())
}
