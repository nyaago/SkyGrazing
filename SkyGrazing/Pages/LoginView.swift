//
//  LoginView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/05/04.
//

import SwiftUI

struct LoginView: View {
    @Environment(BskyService.self) private var service
    @State private var identifier = AppProperty().getString("BskyIdentifier") ?? ""
    @State private var password = AppProperty().getString("BskyPassword") ?? ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Bluesky Login")
                .font(.largeTitle)

            TextField("Handle or Email", text: $identifier)
                .textContentType(.username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)

            TextField("App Password", text: $password)
            //SecureField("App Password", text: $password)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }

            Button("Login") {
                login()
            }
            .buttonStyle(.borderedProminent)
            .disabled(identifier.isEmpty || password.isEmpty || service.isLoading)

            if service.isLoading {
                ProgressView()
            }
        }
        .padding(40)
    }

    private func login() {
        errorMessage = nil
        service.isLoading = true

        Task {
            defer { service.isLoading = false }
            do {
                try await service.login(identifier: identifier, password: password)
            } catch {
                errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(BskyService())
}
