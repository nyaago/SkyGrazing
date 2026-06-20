//
//  TimelineView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/20.
//

import SwiftUI

struct TimelineView: View {
    @Environment(BskyService.self) private var service
    @State private var viewModel = TimelineViewModel()

    var body: some View {
        List(viewModel.feedPosts, id: \.post.cid) { feedPost in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(feedPost.post.author.displayName ?? feedPost.post.author.handle)
                        .font(.headline)
                    Spacer()
                    if let createdAt = feedPost.post.record.createdAt {
                        Text(createdAt)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Text(feedPost.post.record.text ?? "")
                    .font(.body)
            }
            .padding(.vertical, 4)
        }
        .listStyle(.plain)
        .navigationTitle("Timeline")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onAppear { viewModel.onAppear(service: service) }
    }
}

#Preview {
    NavigationStack {
        TimelineView()
    }
    .environment(BskyService())
}
