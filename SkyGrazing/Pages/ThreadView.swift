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
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            }
            if let thread = viewModel.thread {
                PostRowView(postContainer: thread)
            } else {
                ProgressView() // TODO error handling
            }
            List(viewModel.flattenReplies(), id: \.post.cid) { feedPost in
                PostRowView(postContainer: feedPost)
                    .onAppear {
                    }
            }
            .listStyle(.plain)
        }
        .onAppear { viewModel.onAppear(service: service) }
        .onDisappear { viewModel.onDisappear() }

    }
}
