//
//  RepostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/28.
//

import SwiftUI

struct RepostRowView: View {
    let displayPost: PostDisplayKind

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let repostBy = displayPost.feedPost.reason?.by {
                RepostButtonView(repostAuthor: repostBy)
            }
            HStack {
                AuthorButtonView(author: displayPost.post.author)
                Spacer()
                CreatedAtText(createdAt: displayPost.post.record.createdAt)
            }
            PostBodyView(post: displayPost.post)
        }
        .padding(.vertical, 4)
    }
}

