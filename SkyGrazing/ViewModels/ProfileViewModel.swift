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
            let request = BskyProfilesRequest(actors: [handle])
            let client = BskyClient()
            do {
                let profiles = try await client.fetch(request: request)
                if profiles.isError {
                    let error = profiles.error ?? "Unknown Error"
                    let message = profiles.message ?? "Unknown Message"
                    print("error:\(error) ")
                    print("message:\(message)")
                }
                self.profile = profiles.profiles.first
            } catch {
                print("error: \(error)")
            }
        }
    }
}
