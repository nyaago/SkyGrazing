//
//  CurrentPostFooterView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct CurrentPostFooterView: View {
    let postContainer: any BskyPostContainable
    
    var body: some View {
        HStack {
            ReplyCountButtonView(replyCount: postContainer.post.replyCount ?? 0)
            RepostCountButtonView(repostCount: postContainer.post.repostCount ?? 0)
            LikeButtonView(likeCount: postContainer.post.likeCount ?? 0)
            CreatedAtText(createdAt: postContainer.post.record.createdAt)
        }
        .modifier(CellFooterModifier())
    }
}

/*
 #Preview {
 CurrentPostFooterView()
 }
 */
