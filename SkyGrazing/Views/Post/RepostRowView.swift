//
//  RepostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/28.
//

import SwiftUI

struct RepostRowView: View {
    let postContainer: FeedPostWrapper

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let repostBy = postContainer.feedPost.reason?.by {
                RepostButtonView(repostAuthor: repostBy)
            }
            HStack {
                AuthorButtonView(author: postContainer.post.author)
                Spacer()
                CreatedAtText(createdAt: postContainer.post.record.createdAt)
            }
            PostBodyView(post: postContainer.post)
        }
        .padding(.vertical, 4)
    }
}

