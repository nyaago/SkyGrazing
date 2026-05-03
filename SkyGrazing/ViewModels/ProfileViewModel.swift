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
    
    @MainActor
    func onAppear(handle: String, service: BskyService) {
        guard !service.isLoading else { return }
        service.isLoading = true
        
        Task {
            defer { service.isLoading = false }
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
