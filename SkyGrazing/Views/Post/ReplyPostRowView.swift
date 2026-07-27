//
//  ReplyPostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/27.
//

import SwiftUI

struct ReplyPostRowView: View {
    let displayPost: PostDisplayKind

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                AuthorButtonView(author: displayPost.post.author)
                Spacer()
                CreatedAtText(createdAt: displayPost.post.record.createdAt)
            }
            if let parentAuthor = displayPost.feedPost.reply?.parent?.author {
                ReplyToButtonView(parentAuthor: parentAuthor)
            }
            PostBodyView(post: displayPost.post)
        }
        .padding(.vertical, 4)
    }
}
