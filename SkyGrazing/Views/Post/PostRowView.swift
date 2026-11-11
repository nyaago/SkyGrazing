//
//  PostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

import SwiftUI

struct PostRowView: View {
    let postContainer: any BskyPostContainable
    /// 投稿削除時の処理。
    var onDelete: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PostHeaderView(postContainer: postContainer)
            PostBodyView(post: postContainer.post)
            PostFooterView(postContainer: postContainer, onDelete: onDelete)
        }
        .padding(.vertical, 4)
    }
}
