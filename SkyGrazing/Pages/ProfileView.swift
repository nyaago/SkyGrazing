//
//  ProfileView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/06.
//

import SwiftUI

struct ProfileView: View {
    @Environment(BskyService.self) private var service
    @State private var viewModel = MyFeedViewModel()
    
    var body: some View {
        VStack {
            if let profile = viewModel.profile {
                Text(profile.displayName ?? UserSettings.handle)
                    .font(.largeTitle)
                Text(profile.description ?? "")
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .onAppear { viewModel.onAppear(service: service) }
    }
}

#Preview {
    ProfileView()
        .environment(BskyService())
}
