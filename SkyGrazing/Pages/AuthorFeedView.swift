//
//  AuthorFeedView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/08.
//

import SwiftUI

struct AuthorFeedView: View {
    @State var router: TimelineRouter = .init()
    let actor: String

    var body: some View {
        NavigationStack(path: $router.path) {
            FeedView(viewModel: FeedViewModel { limit, cursor in
                BskyAuthorFeedRequest(actor: actor, limit: limit, cursor: cursor)
            })
            .navigationTitle(actor)
        }
        .environment(router)
    }
}

#Preview {
    AuthorFeedView(actor: "nyaago.bsky.social")
        .environment(BskyService())
}
