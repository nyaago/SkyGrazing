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
        List(viewModel.feedPosts, id: \.post.cid) { feedPost in
            PostRowView(postContainer: feedPost)
                .onAppear {
                    if isNearBottom(feedPost) {
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

    private func isNearBottom(_ feedPost: BskyFeedViewPost) -> Bool {
        guard let index = viewModel.feedPosts.firstIndex(where: { $0.post.cid == feedPost.post.cid }) else {
            return false
        }
        return index >= viewModel.feedPosts.count - 3
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
