//
//  PostHeaderView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct PostHeaderView: View {
    let postContainer: any BskyPostContainable

    var body: some View {
        HStack {
            AuthorButtonView(author: postContainer.post.author)
            Text("-").modifier(CaptionModifier())
            RelativeCreatedAtText(createdAt: postContainer.post.record.createdAt)
        }
    }
}

