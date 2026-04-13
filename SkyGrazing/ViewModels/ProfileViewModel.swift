//
//  ProfileViewModel.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/06.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var profile: BskyProfile?
    @Published var isLoading = false
    
    /*
    @Published var isLoggedIn: Bool {
        return profile != nil
    }
     */
    
    private var cancellable = Set<AnyCancellable>()
    
    func onAppear(handle: String) {
        let request = BskyProfileRequest(handle: handle)
        let client = BskyClient()
        isLoading = true
        
        client.fetch(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print("値の受け取りが完了しました:\(completion)")
                self.isLoading = false
            }, receiveValue: { profile in
                if profile.isError {
                    let error = profile.error ?? "Unknown Error"
                    let message = profile.message ?? "Unknown Message"
                    print("error:\(error) ")
                    print("message:\(message)")
                }
                print("受け取った値は:\(profile)")
                self.profile = profile
            })
            .store(in: &cancellable)
    }
}
