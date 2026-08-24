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
    @State var router: TimelineRouter = .init()
    
    var body: some View {
        NavigationStack(path: $router.path) {
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
        .environment(router)
    }
}

#Preview {
    ProfileView()
        .environment(BskyService())
}
