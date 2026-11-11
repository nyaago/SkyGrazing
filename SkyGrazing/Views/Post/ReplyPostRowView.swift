//
//  ReplyPostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/27.
//

import SwiftUI

struct ReplyPostRowView: View {
    let postContainer: FeedPostWrapper
    /// 投稿削除時の処理。
    var onDelete: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PostHeaderView(postContainer: postContainer)
            if let parentAuthor = postContainer.feedPost.reply?.parent?.author {
                ReplyToButtonView(parentAuthor: parentAuthor)
            }
            PostBodyView(post: postContainer.post)
            PostFooterView(postContainer: postContainer, onDelete: onDelete)
        }
        .padding(.vertical, 4)
    }
}
