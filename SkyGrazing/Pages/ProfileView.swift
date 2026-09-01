//
//  ProfileView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/06.
//

import SwiftUI

struct ProfileView: View {
    let actor: String

    @Environment(BskyService.self) private var service
    @State private var viewModel: ProfileViewModel
    @Environment(TimelineRouter.self) private var router
    @State private var selectedTab: ProfileTab = .posts

    init(actor: String) {
        self.actor = actor
        self._viewModel = State(initialValue: ProfileViewModel(handle: actor))
    }

    var body: some View {
        VStack {
            if viewModel.isLoadingProfile {
                ProgressView()
            }
            else {
                if let profile = viewModel.profile {
                    ProfileHeaderView(profile: profile, selectedTab: $selectedTab)
                    FeedView(viewModel: FeedViewModel { limit, cursor in
                        BskyAuthorFeedRequest(actor: profile.handle, limit: limit, cursor: cursor)
                    })
                    .environment(\.profileActor, profile.handle)
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
    ProfileView(actor: UserSettings.handle)
        .environment(BskyService())
        .environment(TimelineRouter())
}
