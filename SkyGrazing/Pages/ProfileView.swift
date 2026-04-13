//
//  ProfileView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/06.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    let handle: String
    
    var body: some View {
        VStack {
            if let profile = viewModel.profile {
                Text(profile.displayName ?? handle)
                    .font(.largeTitle)
                Text(profile.description ?? "")
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .onAppear { viewModel.onAppear(handle: handle) }
    }
}

#Preview {
    ProfileView(handle: "nyaago.bsky.social")
}
