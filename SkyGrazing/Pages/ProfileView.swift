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
    /// フォロワー一覧のフローティング表示中か
    @State private var showFollowers = false

    init(actor: String) {
        self.actor = actor
        self._viewModel = State(initialValue: ProfileViewModel(handle: actor))
    }

    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoadingProfile {
                    ProgressView()
                }
                else {
                    if let profile = viewModel.profile {
                        ProfileHeaderView(profile: profile,
                                          selectedSection: $selectedSection,
                                          onSelectFollowers: { showFollowers = true })
                        sectionContent
                    }
                }
            }

            if showFollowers {
                followersOverlay
            }
        }
        .navigationDestination(for: TimelineRoute.self) { route in
            router.destination(for: route)
        }
        .onAppear { viewModel.onAppearProfile(service: service) }
    }

    /// メインコンテンツの上に重ねるフォロワー一覧。下部に配置し、高さは最大60%、横は100%。
    private var followersOverlay: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { showFollowers = false }

                FollowersView(actor: actor) { showFollowers = false }
                    .frame(width: geo.size.width)
                    .frame(maxHeight: geo.size.height * 0.6)
            }
        }
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
