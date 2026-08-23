//
//  PostFooterView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct PostFooterView: View {
    let postContainer: any BskyPostContainable
    
    var body: some View {
        HStack {
            ReplyCountButtonView(replyCount: postContainer.post.replyCount ?? 0)
                .modifier(CellActionButtonModifier())
            RepostCountButtonView(repostCount: postContainer.post.repostCount ?? 0)
                .modifier(CellActionButtonModifier())
            LikeButtonView(likeCount: postContainer.post.likeCount ?? 0)
                .modifier(CellActionButtonModifier())
        }
        .modifier(CellFooterModifier())
    }
}

/*
 #Preview {
 PostFooterView()
 }
 */
