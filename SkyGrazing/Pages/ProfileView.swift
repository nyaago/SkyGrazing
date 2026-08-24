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
    @Environment(TimelineRouter.self) private var router
    
    var body: some View {
        VStack {
            if viewModel.isLoadingProfile {
                ProgressView()
            }
            else {
                if let profile = viewModel.profile {
                    ProfileHeaderView(profile: profile)
                    FeedView(viewModel: FeedViewModel { limit, cursor in
                        BskyAuthorFeedRequest(actor: profile.handle, limit: limit, cursor: cursor)
                    })
                }
            }
        }
        .navigationDestination(for: TimelineRoute.self) { route in
            router.destination(for: route)
        }
        .onAppear { viewModel.onAppearProfile(service: service) }
    }
}

#Preview {
    ProfileView()
        .environment(BskyService())
        .environment(TimelineRouter())
}
