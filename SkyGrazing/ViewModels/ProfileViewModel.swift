//
//  ProfileViewModel.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/06.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profile: BskyProfile?
    @Published var isLoading = false
    
    @MainActor
    func onAppear(handle: String) {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            defer { isLoading = false }
            let request = BskyProfileRequest(handle: handle)
            let client = BskyClient()
            do {
                let profile = try await client.fetch(request: request)
                if profile.isError {
                    let error = profile.error ?? "Unknown Error"
                    let message = profile.message ?? "Unknown Message"
                    print("error:\(error) ")
                    print("message:\(message)")
                }
                self.profile = profile
            } catch {
                print("error: \(error)")
            }
        }
    }
}
