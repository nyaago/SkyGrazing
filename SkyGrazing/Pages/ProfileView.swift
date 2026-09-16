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
    @State private var selectedSection: ProfileSection = .posts

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
                    ProfileHeaderView(profile: profile, selectedSection: $selectedSection)
                    sectionContent
                }
            }
        }
        .navigationDestination(for: TimelineRoute.self) { route in
            router.destination(for: route)
        }
        .onAppear { viewModel.onAppearProfile(service: service) }
    }

    @ViewBuilder
    private var sectionContent: some View {
        if let profile = viewModel.profile {
            let isOwner = profile.handle == UserSettings.handle
            switch selectedSection {
            case .posts, .media, .feeds:
                // Media / Feeds は仮で Posts と同じ扱い
                postsFeed(for: profile, filter: "posts_no_replies")
            case .replies:
                postsFeed(for: profile, filter: "posts_with_replies")
            case .likes:
                if isOwner {
                    likesFeed(for: profile)
                } else {
                    // Likes は本人のみ表示。非本人の場合は Posts にフォールバック
                    postsFeed(for: profile, filter: "posts_no_replies")
                }
            }
        }
    }

    private func postsFeed(for profile: BskyProfile, filter: String) -> some View {
        FeedView(viewModel: FeedViewModel { limit, cursor in
            BskyAuthorFeedRequest(actor: profile.handle, limit: limit, cursor: cursor, filter: filter)
        })
        .environment(\.profileActor, profile.handle)
    }

    private func likesFeed(for profile: BskyProfile) -> some View {
        FeedView(viewModel: FeedViewModel { limit, cursor in
            BskyActorLikesRequest(actor: profile.handle, limit: limit, cursor: cursor)
        })
        .environment(\.profileActor, profile.handle)
    }
}

#Preview {
    ProfileView(actor: UserSettings.handle)
        .environment(BskyService())
        .environment(TimelineRouter())
}
