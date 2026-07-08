//
//  TimelineView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/22.
//

import SwiftUI

struct TimelineView: View {
    @State var router: TimelineRouter = .init()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            FeedView(viewModel: FeedViewModel { limit, cursor in
                    BskyTimelineRequest(limit: limit, cursor: cursor)
                })
                .navigationTitle("Timeline")
                .navigationDestination(for: TimelineRoute.self) { route in
                    switch route {
                    case .profile(let author):
                        AuthorFeedView(actor: author.handle)
                            .environment(router)
                    case .post(let post):
                        Text(post.record.text ?? "")
                    }
                }

        }
        .environment(router)
    }
}

#Preview {
    NavigationStack {
        TimelineView()
    }
    .environment(BskyService())
}
