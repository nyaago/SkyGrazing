//
//  ReplyPostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/27.
//

import SwiftUI

struct ReplyPostRowView: View {
    let postContainer: FeedPostWrapper

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                AuthorButtonView(author: postContainer.post.author)
                Spacer()
                CreatedAtText(createdAt: postContainer.post.record.createdAt)
            }
            if let parentAuthor = postContainer.feedPost.reply?.parent?.author {
                ReplyToButtonView(parentAuthor: parentAuthor)
            }
            PostBodyView(post: postContainer.post)
        }
        .padding(.vertical, 4)
    }
}
