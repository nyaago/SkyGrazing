//
//  RepostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/28.
//

import SwiftUI

struct RepostRowView: View {
    let postContainer: FeedPostWrapper
    /// 投稿削除時の処理。
    var onDelete: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let repostBy = postContainer.feedPost.reason?.by {
                RepostButtonView(repostAuthor: repostBy)
            }
            PostHeaderView(postContainer: postContainer)
            PostBodyView(post: postContainer.post)
            PostFooterView(postContainer: postContainer, onDelete: onDelete)
        }
        .padding(.vertical, 4)
    }
}

