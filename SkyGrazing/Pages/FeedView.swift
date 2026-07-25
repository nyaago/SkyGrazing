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
                element(for: displayPost)
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

    private func element(for post: PostDisplayKind) -> some View {
        Group {
            // @todo: kind ごとに対応する View を実装して切り替える
            switch post {
                case .regular:
                    PostRowView(postContainer: post)
                case .reply:
                    PostRowView(postContainer: post)
                case .repost:
                    PostRowView(postContainer: post)
            }
        }
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
