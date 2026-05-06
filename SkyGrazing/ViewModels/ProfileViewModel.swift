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
    var isLoading = false
    var profile: BskyProfile?
    
    @MainActor
    func onAppear(handle: String, service: BskyService) {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            defer { isLoading = false }
            let request = BskyProfileRequest(actor: handle)
            do {
                self.profile = try await service.fetch(request)
                // TODO エラー時の UI の処理
                /*
                 } catch let error as BskyApiError {
                 switch error {
                 case .apiError(let error, let message):
                 print("API error: \(error) - \(message)")
                 }
                 
                 }
                 */
            } catch {
                print("error: \(error)")
            }
        }
    }
}
