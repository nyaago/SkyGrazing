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
                .modifier(CellFooterElementModifier())
            RepostCountButtonView(repostCount: postContainer.post.repostCount ?? 0)
                .modifier(CellFooterElementModifier())
            LikeButtonView(likeCount: postContainer.post.likeCount ?? 0)
                .modifier(CellFooterElementModifier())
            CreatedAtText(createdAt: postContainer.post.record.createdAt)
                .modifier(CellFooterElementModifier())
        }
        .modifier(CellFooterModifier())
    }
}

/*
 #Preview {
 CurrentPostFooterView()
 }
 */
