//
//  ProfileView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/06.
//

import SwiftUI

struct ProfileView: View {
    @Environment(BskyService.self) private var service
    @State private var viewModel = ProfileViewModel()
    let handle: String
    
    var body: some View {
        VStack {
            if let profile = viewModel.profile {
                Text(profile.displayName ?? handle)
                    .font(.largeTitle)
                Text(profile.description ?? "")
            } else if service.isLoading {
                ProgressView()
            }
        }
        .onAppear { viewModel.onAppear(handle: handle, service: service) }
    }
}

#Preview {
    ProfileView(handle: "nyaago.bsky.social")
        .environment(BskyService())
}
