// Utils/DocumentPicker.swift
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedDocument: DocumentInfo?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            // Verificar que sea PDF
            guard url.pathExtension.lowercased() == "pdf" else {
                print("[ERROR] Archivo seleccionado no es PDF")
                return
            }
            
            do {
                // Obtener datos del archivo
                let data = try Data(contentsOf: url)
                
                // Verificar tamaño (máximo 10MB)
                let maxSize = 10 * 1024 * 1024 // 10MB
                guard data.count <= maxSize else {
                    print("[ERROR] Archivo demasiado grande")
                    return
                }
                
                let fileName = url.lastPathComponent
                let fileSize = data.count
                
                let documentInfo = DocumentInfo(
                    name: fileName,
                    data: data,
                    size: fileSize,
                    url: url
                )
                
                DispatchQueue.main.async {
                    self.parent.selectedDocument = documentInfo
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
                
            } catch {
                print("[ERROR] Error al leer archivo: \(error)")
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Document Info Model
struct DocumentInfo: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let data: Data
    let size: Int
    let url: URL
    
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
    
    var isValidPDF: Bool {
        return name.lowercased().hasSuffix(".pdf") && data.count > 0
    }
    
    static func == (lhs: DocumentInfo, rhs: DocumentInfo) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.size == rhs.size &&
               lhs.url == rhs.url &&
               lhs.data == rhs.data
    }
}

// MARK: - Document Picker Button View
struct DocumentPickerButton: View {
    @Binding var selectedDocument: DocumentInfo?
    @State private var showingDocumentPicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var backgroundColor: Color {
        selectedDocument != nil ? Color.green.opacity(0.1) : Color.gray.opacity(0.1)
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(
                selectedDocument != nil ? Color.green : Color.gray.opacity(0.3),
                lineWidth: 1.5
            )
    }
    
    var body: some View {
        Button(action: {
            showingDocumentPicker = true
        }) {
            VStack(spacing: 16) {
                if let document = selectedDocument {
                    // Documento seleccionado
                    VStack(spacing: 12) {
                        Image(systemName: "doc.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.primaryOrange)
                        
                        VStack(spacing: 4) {
                            Text(document.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            
                            Text(document.formattedSize)
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.green)
                            
                            Text("PDF seleccionado")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.green)
                        }
                        
                        Button(action: {
                            selectedDocument = nil
                        }) {
                            Text("Cambiar archivo")
                                .font(.system(size: 12))
                                .foregroundColor(.primaryOrange)
                        }
                        .padding(.top, 4)
                    }
                    
                } else {
                    // Estado inicial
                    VStack(spacing: 12) {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        VStack(spacing: 6) {
                            Text("Subir CV")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            Text("Selecciona un archivo PDF de tu currículum")
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Text("Máximo 10MB • Solo PDF")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(backgroundColor)
            .overlay(borderOverlay)
            .cornerRadius(8)
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker(selectedDocument: $selectedDocument)
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onChange(of: selectedDocument) { document in
            if let doc = document {
                // Validar que sea PDF válido
                if !doc.isValidPDF {
                    alertMessage = "El archivo seleccionado no es un PDF válido"
                    showingAlert = true
                    selectedDocument = nil
                }
                // Validar tamaño
                else if doc.size > 10 * 1024 * 1024 {
                    alertMessage = "El archivo es demasiado grande. Máximo 10MB"
                    showingAlert = true
                    selectedDocument = nil
                }
            }
        }
    }
}