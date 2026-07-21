//
//  ThreadView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

import SwiftUI

struct ThreadView: View {
    @Environment(BskyService.self) private var service
    @State private var viewModel: ThreadViewModel

    init(uri: String) {
        _viewModel = State(initialValue: ThreadViewModel(uri: uri))
    }

    var body: some View {
        List(viewModel.displayPosts(), id: \.post.cid) { displayPost in
            Group {
                // @todo: kind ごとに対応する View を実装して切り替える
                switch displayPost {
                case .parent:
                    PostRowView(postContainer: displayPost)
                case .current:
                    PostRowView(postContainer: displayPost)
                case .reply:
                    PostRowView(postContainer: displayPost)
                }
            }
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onAppear { viewModel.onAppear(service: service) }
        .onDisappear { viewModel.onDisappear() }

    }
}
