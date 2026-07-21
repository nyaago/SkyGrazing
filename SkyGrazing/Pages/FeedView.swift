//
//  FeedView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/20.
//

import SwiftUI

struct FeedView<ViewModel: FeedViewModelProtocol>: View {
    @Environment(BskyService.self) private var service
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List(viewModel.displayPosts, id: \.post.cid) { displayPost in
            Group {
                switch displayPost {
                // @todo: kind ごとに対応する View を実装して切り替える
                case .regular:
                    PostRowView(postContainer: displayPost)
                case .reply:
                    PostRowView(postContainer: displayPost)
                case .repost:
                    PostRowView(postContainer: displayPost)
                }
            }
            .onAppear {
                if isNearBottom(displayPost) {
                    viewModel.loadMore(service: service)
                }
            }
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isLoading && viewModel.feedPosts.isEmpty {
                ProgressView()
            }
        }
        .onAppear { viewModel.onAppear(service: service) }
        .onDisappear { viewModel.onDisappear() }
    }

    private func isNearBottom(_ displayPost: PostDisplayKind) -> Bool {
        let posts = viewModel.displayPosts
        guard let index = posts.firstIndex(where: { $0.post.cid == displayPost.post.cid }) else {
            return false
        }
        return index >= posts.count - 3
    }
}

#Preview {
    NavigationStack {
        FeedView(viewModel: FeedViewModel { limit, cursor in
            BskyTimelineRequest(limit: limit, cursor: cursor)
        })
    }
    .environment(BskyService())
}
