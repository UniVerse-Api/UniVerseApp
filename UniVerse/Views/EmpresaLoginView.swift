// Views/LoginEmpresaView.swift
import SwiftUI
import WebKit

struct LoginEmpresaView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var webViewModel = WebViewModel()
    
    var body: some View {
        ZStack {
            // WebView
            WebView(viewModel: webViewModel)	
                .ignoresSafeArea()
            
            // Indicador de carga
            if webViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.8))
            }
        }
        .navigationBarHidden(true)
        .onReceive(webViewModel.$shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
    }
}

// MARK: - WebViewModel
@MainActor
class WebViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var shouldDismiss = false
    
    let webView: WKWebView
    
    init() {
        // Configuración del WebView
        let configuration = WKWebViewConfiguration()
        
        // Configurar el UserContentController para recibir mensajes desde JavaScript
        let contentController = WKUserContentController()
        configuration.userContentController = contentController
        
        // Configurar preferencias
        configuration.preferences.javaScriptEnabled = true
        configuration.allowsInlineMediaPlayback = true
        
        // Crear WebView
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        
        // Configurar después de crear el webView
        setupMessageHandlers()
        loadURL()
    }
    
    private func setupMessageHandlers() {
        // Handler para cerrar sesión / regresar al login
        webView.configuration.userContentController.add(
            MessageHandler { [weak self] message in
                self?.handleMessage(message)
            },
            name: "universeApp"
        )
    }
    
    private func handleMessage(_ message: [String: Any]) {
        print("[WebView] Mensaje recibido desde web:", message)
        
        guard let action = message["action"] as? String else {
            print("[WebView] No se encontró action en el mensaje")
            return
        }
        
        switch action {
        case "logout":
            print("[WebView] Cerrando sesión de empresa y regresando a login estudiantes")
            shouldDismiss = true
            
        case "navigateToStudentLogin":
            print("[WebView] Navegando a login de estudiantes")
            shouldDismiss = true
            
        case "ready":
            print("[WebView] WebView está listo")
            
        default:
            print("[WebView] Acción no reconocida: \(action)")
        }
    }
    
    private func loadURL() {
        guard let url = URL(string: "https://universe-frontend.netlify.app") else {
            print("[WebView] URL inválida")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// MARK: - WebView UIViewRepresentable
struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    
    func makeUIView(context: Context) -> WKWebView {
        viewModel.webView.navigationDelegate = context.coordinator
        return viewModel.webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No necesitamos actualizar nada
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("[WebView] Iniciando carga...")
            parent.viewModel.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("[WebView] Carga completada")
            parent.viewModel.isLoading = false
            
            // Inyectar JavaScript para establecer comunicación
            let js = """
            (function() {
                // Función helper para enviar mensajes a Swift
                window.sendToSwift = function(action, data = {}) {
                    if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.universeApp) {
                        window.webkit.messageHandlers.universeApp.postMessage({
                            action: action,
                            ...data
                        });
                    }
                };
                
                // Notificar que el WebView está listo
                window.sendToSwift('ready');
                
                console.log('[UniVerse] Bridge de comunicación con Swift establecido');
            })();
            """
            
            webView.evaluateJavaScript(js) { result, error in
                if let error = error {
                    print("[WebView] Error al inyectar JavaScript:", error)
                } else {
                    print("[WebView] JavaScript inyectado exitosamente")
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("[WebView] Error en la navegación:", error.localizedDescription)
            parent.viewModel.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("[WebView] Error al cargar la página:", error.localizedDescription)
            parent.viewModel.isLoading = false
        }
    }
}

// MARK: - MessageHandler
class MessageHandler: NSObject, WKScriptMessageHandler {
    let handler: ([String: Any]) -> Void
    
    init(handler: @escaping ([String: Any]) -> Void) {
        self.handler = handler
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let body = message.body as? [String: Any] {
            handler(body)
        } else {
            print("[MessageHandler] Mensaje recibido no es un diccionario:", message.body)
        }
    }
}

#Preview {
    NavigationView {
        LoginEmpresaView()
            .environmentObject(AuthViewModel())
    }
}
