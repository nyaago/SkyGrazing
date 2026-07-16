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
    @Environment(TimelineRouter.self) private var router
    
    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List(viewModel.feedPosts, id: \.post.cid) { feedPost in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    authorButton(feedPost)
                    Spacer()
                    createdAt(feedPost)
                }
                postButton(feedPost)
            }
            .padding(.vertical, 4)
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

    @ViewBuilder
    private func postButton(_ feedPost: BskyFeedViewPost) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                print("push: \(feedPost.post.cid)")
                router.push(.post(feedPost.post))
            } label: {
                Text(feedPost.post.record.text ?? "")
                    .modifier(BodyTextModifier())
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private func authorButton(_ feedPost: BskyFeedViewPost) -> some View {
        Button {
            print("push: \(feedPost.post.author)")
            router.push(.profile(feedPost.post.author))
        } label: {
            Text(feedPost.post.author.displayName ?? feedPost.post.author.handle)
                .modifier(HeadlineModifier())
            Text("@" + feedPost.post.author.handle)
                .modifier(CaptionModifier())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private func createdAt(_ feedPost: BskyFeedViewPost) -> some View {
        if let createdAt = feedPost.post.record.createdAt {
            Text(createdAt).modifier(CaptionModifier())
        }
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
