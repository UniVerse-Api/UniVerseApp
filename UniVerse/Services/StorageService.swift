// Services/StorageService.swift
import Foundation
import Supabase
import UIKit

class StorageService {
    static let shared = StorageService()
    
    private let supabase = SupabaseManager.shared.client
    
    private init() {}
    
    // MARK: - Avatar Upload
    func uploadAvatar(_ image: UIImage, userId: String) async throws -> String {
        // Convertir String a UUID
        guard let userUUID = UUID(uuidString: userId) else {
            throw StorageError.uploadFailed("ID de usuario inválido")
        }
        
        // Comprimir la imagen
        guard let imageData = compressImage(image) else {
            throw StorageError.compressionFailed
        }
        
        let fileName = "avatar_\(userUUID.uuidString)_\(Int(Date().timeIntervalSince1970)).jpg"
        
        do {
            // Subir a bucket avatars
            let path = try await supabase.storage
                .from("avatars")
                .upload(path: fileName, file: imageData, options: FileOptions(contentType: "image/jpeg"))
            
            // Obtener URL público
            let url = try supabase.storage
                .from("avatars")
                .getPublicURL(path: fileName)
            
            return url.absoluteString
            
        } catch {
            print("[ERROR] Error subiendo avatar: \(error)")
            throw StorageError.uploadFailed(error.localizedDescription)
        }
    }
    
    // MARK: - Document Upload
    func uploadPDF(_ documentData: Data, fileName: String, userId: String) async throws -> (url: String, name: String) {
        // Convertir String a UUID
        guard let userUUID = UUID(uuidString: userId) else {
            throw StorageError.uploadFailed("ID de usuario inválido")
        }
        
        // Validar que sea PDF
        guard isPDF(data: documentData) else {
            throw StorageError.invalidFileType
        }
        
        // Crear nombre único
        let fileExtension = URL(fileURLWithPath: fileName).pathExtension
        let uniqueFileName = "cv_\(userUUID.uuidString)_\(Int(Date().timeIntervalSince1970)).\(fileExtension)"
        
        do {
            // Subir a bucket docs
            let path = try await supabase.storage
                .from("docs")
                .upload(path: uniqueFileName, file: documentData, options: FileOptions(contentType: "application/pdf"))
            
            // Obtener URL público
            let url = try supabase.storage
                .from("docs")
                .getPublicURL(path: uniqueFileName)
            
            return (url: url.absoluteString, name: fileName)
            
        } catch {
            print("[ERROR] Error subiendo PDF: \(error)")
            throw StorageError.uploadFailed(error.localizedDescription)
        }
    }
    
    // MARK: - Delete Files
    func deleteAvatar(fileName: String) async throws {
        do {
            let paths = try await supabase.storage
                .from("avatars")
                .remove(paths: [fileName])
            
            print("[DEBUG] Avatar eliminado: \(paths)")
            
        } catch {
            print("[ERROR] Error eliminando avatar: \(error)")
            throw StorageError.deleteFailed(error.localizedDescription)
        }
    }
    
    func deleteDocument(fileName: String) async throws {
        do {
            let paths = try await supabase.storage
                .from("docs")
                .remove(paths: [fileName])
            
            print("[DEBUG] Documento eliminado: \(paths)")
            
        } catch {
            print("[ERROR] Error eliminando documento: \(error)")
            throw StorageError.deleteFailed(error.localizedDescription)
        }
    }
    
    // MARK: - Utility Methods
    private func compressImage(_ image: UIImage) -> Data? {
        // Redimensionar la imagen si es muy grande
        let targetSize = CGSize(width: 800, height: 800)
        let resizedImage = image.resized(to: targetSize)
        
        // Comprimir con calidad 0.7
        return resizedImage.jpegData(compressionQuality: 0.7)
    }
    
    private func isPDF(data: Data) -> Bool {
        // Verificar que los primeros bytes correspondan a un PDF
        let pdfSignature = Data([0x25, 0x50, 0x44, 0x46]) // "%PDF"
        if data.count >= 4 {
            let headerData = data.prefix(4)
            return headerData == pdfSignature
        }
        return false
    }
}

// MARK: - Storage Errors
enum StorageError: LocalizedError {
    case compressionFailed
    case uploadFailed(String)
    case deleteFailed(String)
    case invalidFileType
    case fileTooLarge
    
    var errorDescription: String? {
        switch self {
        case .compressionFailed:
            return "Error al comprimir la imagen"
        case .uploadFailed(let message):
            return "Error al subir archivo: \(message)"
        case .deleteFailed(let message):
            return "Error al eliminar archivo: \(message)"
        case .invalidFileType:
            return "Solo se permiten archivos PDF"
        case .fileTooLarge:
            return "El archivo es demasiado grande"
        }
    }
}

// MARK: - UIImage Extension
extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determinar qué ratio usar
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // Crear el contexto y dibujar
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}