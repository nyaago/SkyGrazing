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
        List(viewModel.flattenPosts(), id: \.post.cid) { feedPost in
            PostRowView(postContainer: feedPost)
                .onAppear {
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
