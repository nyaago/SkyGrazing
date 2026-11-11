//
//  PostFooterView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct PostFooterView: View {
    let postContainer: any BskyPostContainable
    /// 投稿削除時の処理。指定されたときだけ削除メニューを表示する。
    var onDelete: (() -> Void)? = nil

    /// ログイン中ユーザー自身の投稿かどうか。
    private var isOwnPost: Bool {
        postContainer.post.author.handle == UserSettings.handle
    }

    var body: some View {
        HStack {
            ReplyCountButtonView(replyCount: postContainer.post.replyCount ?? 0)
                .modifier(CellActionButtonModifier())
            RepostCountButtonView(repostCount: postContainer.post.repostCount ?? 0)
                .modifier(CellActionButtonModifier())
            LikeButtonView(likeCount: postContainer.post.likeCount ?? 0)
                .modifier(CellActionButtonModifier())
            if isOwnPost, let onDelete {
                Spacer()
                PostMenuButtonView(onDelete: onDelete)
            }
        }
        .modifier(CellFooterModifier())
    }
}

/*
 #Preview {
 PostFooterView()
 }
 */
