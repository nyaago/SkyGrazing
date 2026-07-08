//
//  AuthorFeedView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/08.
//

import SwiftUI

struct AuthorFeedView: View {
    let actor: String

    var body: some View {
        FeedView(viewModel: FeedViewModel { limit, cursor in
            BskyAuthorFeedRequest(actor: actor, limit: limit, cursor: cursor)
        })
        .navigationTitle(actor)
    }
}

#Preview {
    AuthorFeedView(actor: "nyaago.bsky.social")
        .environment(BskyService())
}
