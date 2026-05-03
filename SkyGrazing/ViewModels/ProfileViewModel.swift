//
//  ProfileViewModel.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/06.
//

import Foundation
import Observation

@Observable
class ProfileViewModel {
    var profile: BskyProfile?
    var isLoading = false
    
    @MainActor
    func onAppear(handle: String) {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            defer { isLoading = false }
            let request = BskyProfileRequest(actor: handle)
            let client = BskyClient()
            do {
                let _ = try await client.login()
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
