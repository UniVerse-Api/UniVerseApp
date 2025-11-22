// Views/CreatePostView.swift
import SwiftUI

struct CreatePostView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var viewModel = CreatePostViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                            .foregroundColor(.textPrimary)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("Crear publicación")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Button(action: {
                        Task {
                            guard let user = authVM.currentUser,
                                  let perfil = user.perfil else { return }

                            await viewModel.createPost(userId: user.id.uuidString, profileId: perfil.id)
                        }
                    }) {
                        Text("Publicar")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(viewModel.isFormValid ? .primaryOrange : .gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.isFormValid ? Color.primaryOrange.opacity(0.1) : Color.gray.opacity(0.1))
                            .cornerRadius(20)
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.cardBackground.opacity(0.95))
                .overlay(
                    Rectangle()
                        .fill(Color.borderColor)
                        .frame(height: 1)
                        .padding(.top, 44)
                )

                ScrollView {
                    VStack(spacing: 20) {
                        // Error Message
                        if let error = viewModel.errorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 14))

                                Text(error)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.leading)

                                Spacer()
                            }
                            .padding(16)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal, 16)
                        }

                        // Success Message
                        if viewModel.showSuccess {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 14))

                                Text("¡Publicación creada exitosamente!")
                                    .font(.system(size: 14))
                                    .foregroundColor(.green)

                                Spacer()
                            }
                            .padding(16)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal, 16)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }

                        // Form
                        VStack(spacing: 20) {
                            // Título
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Título")
                                    .font(.system(size: 13))
                                    .foregroundColor(.textSecondary)

                                TextField("Escribe un título atractivo...", text: $viewModel.titulo)
                                    .foregroundColor(.textPrimary)
                                    .textInputAutocapitalization(.words)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .background(Color.inputBackground)
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                            }

                            // Descripción
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Descripción")
                                    .font(.system(size: 13))
                                    .foregroundColor(.textSecondary)

                                ZStack(alignment: .topLeading) {
                                    if viewModel.descripcion.isEmpty {
                                        Text("Comparte tus pensamientos, experiencias o conocimientos...")
                                            .foregroundColor(.textSecondary.opacity(0.6))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 12)
                                    }

                                    TextEditor(text: $viewModel.descripcion)
                                        .foregroundColor(.textPrimary)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 8)
                                        .background(Color.inputBackground)
                                        .cornerRadius(6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.borderColor, lineWidth: 1)
                                        )
                                        .frame(minHeight: 120)
                                }
                            }

                            // Imagen opcional
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Imagen (opcional)")
                                    .font(.system(size: 13))
                                    .foregroundColor(.textSecondary)

                                HStack(spacing: 16) {
                                    // Image Picker
                                    ImagePickerOptions(selectedImage: $viewModel.selectedImage)

                                    if let image = viewModel.selectedImage {
                                        VStack(spacing: 8) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 80, height: 80)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                            Button(action: {
                                                viewModel.removeImage()
                                            }) {
                                                Text("Remover")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }

                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .overlay(
            Group {
                if viewModel.isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .overlay(
                            VStack(spacing: 16) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                    .tint(.white)

                                Text("Creando publicación...")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        )
                }
            }
        )
    }
}

#Preview {
    NavigationView {
        CreatePostView()
            .environmentObject(AuthViewModel())
    }
}
