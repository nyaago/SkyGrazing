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
    @State private var isComposePresented = false
    
    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollViewReader { proxy in
            List(viewModel.displayPosts, id: \.post.cid) { displayPost in
                Group {
                    element(for: displayPost)
                }
                .onAppear {
                    if isNearBottom(displayPost) {
                        viewModel.loadMore(service: service)
                    }
                }
                .listRowSeparator(.visible, edges: .bottom)
                .listRowSeparator(.hidden, edges: .top)
                
            }
            .listStyle(.plain)
            .overlay {
                if viewModel.isLoading && viewModel.feedPosts.isEmpty {
                    ProgressView()
                }
            }
            .overlay(alignment: .bottomTrailing) {
                CircleIconButton(action: { isComposePresented = true },
                                 imageName: "square.and.pencil")
                    .padding()
            }
            .modifier(ResponsiveModalModifier(isPresented: $isComposePresented) {
                ComposePostView(onPosted: { reloadAndScrollToTop(proxy: proxy) })
            })
            .onAppear { viewModel.onAppear(service: service) }
            .onDisappear { viewModel.onDisappear() }
        }
    }

    /// 投稿後に最新を読み込み、一番上の投稿までスクロールする。
    private func reloadAndScrollToTop(proxy: ScrollViewProxy) {
        Task {
            await viewModel.reload(service: service)
            if let topId = viewModel.displayPosts.first?.post.cid {
                withAnimation {
                    proxy.scrollTo(topId, anchor: .top)
                }
            }
        }
    }

    private func element(for post: FeedPostWrapper) -> some View {
        Group {
            // @todo: kind ごとに対応する View を実装して切り替える
            switch post {
                case .regular:
                    PostRowView(postContainer: post)
                case .reply:
                    ReplyPostRowView(postContainer: post)
                case .repost:
                    RepostRowView(postContainer: post)
            }
        }
    }
    
    private func isNearBottom(_ displayPost: FeedPostWrapper) -> Bool {
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
