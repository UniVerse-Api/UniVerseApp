// ViewModels/CreatePostViewModel.swift
import SwiftUI
import Combine

class CreatePostViewModel: ObservableObject {
    @Published var titulo = ""
    @Published var descripcion = ""
    @Published var selectedImage: UIImage?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSuccess = false

    private let postService = PostService.shared
    private let storageService = StorageService.shared

    // MARK: - Validation

    var isFormValid: Bool {
        !titulo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !descripcion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Create Post

    func createPost(userId: String, profileId: Int) async {
        guard isFormValid else {
            errorMessage = "Por favor completa todos los campos requeridos"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            var imageUrl: String? = nil

            // Subir imagen si existe
            if let image = selectedImage {
                imageUrl = try await storageService.uploadPostImage(image, userId: userId)
                print("DEBUG: Image uploaded successfully: \(imageUrl ?? "nil")")
            }

            // Crear publicación
            let postId = try await postService.createPublication(
                idPerfil: profileId,
                titulo: titulo.trimmingCharacters(in: .whitespacesAndNewlines),
                descripcion: descripcion.trimmingCharacters(in: .whitespacesAndNewlines),
                urlRecurso: imageUrl
            )

            print("DEBUG: Post created successfully with ID: \(postId)")

            // Reset form
            titulo = ""
            descripcion = ""
            selectedImage = nil
            showSuccess = true

        } catch {
            print("DEBUG: Error creating post: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Helper Methods

    func removeImage() {
        selectedImage = nil
    }
}
