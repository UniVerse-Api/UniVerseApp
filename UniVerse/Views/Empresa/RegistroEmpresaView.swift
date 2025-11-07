// Empresa/RegistroEmpresaView.swift

import SwiftUI

struct RegistroEmpresaView: View {
    var body: some View {
        VStack {
            Text("Registro de Empresa")
                .font(.title)
                .padding()
            
            Text("Esta es la vista para el registro de empresas")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    RegistroEmpresaView()
}
