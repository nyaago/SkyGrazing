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
            listView
            .overlay {
                if viewModel.isLoading && viewModel.feedPosts.isEmpty {
                    ProgressView()
                }
            }
            .overlay(alignment: .bottomTrailing) {
                postButton
            }
            .modifier(ResponsiveModalModifier(isPresented: $isComposePresented) {
                ComposePostView(onPosted: { reloadAndScrollToTop(proxy: proxy) })
            })
            .onAppear { viewModel.onAppear(service: service) }
            .onDisappear { viewModel.onDisappear() }
        }
    }

    private var listView: some View {
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
    }
    
    private var postButton: some View {
        CircleIconButton(action: { isComposePresented = true },
                         imageName: "square.and.pencil")
            .padding()
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
                    PostRowView(postContainer: post, onDelete: { deletePost(post) })
                case .reply:
                    ReplyPostRowView(postContainer: post, onDelete: { deletePost(post) })
                case .repost:
                    RepostRowView(postContainer: post, onDelete: { deletePost(post) })
            }
        }
    }

    /// 投稿を削除し、List から取り除く。
    private func deletePost(_ post: FeedPostWrapper) {
        Task {
            await viewModel.deletePost(post.post, service: service)
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
