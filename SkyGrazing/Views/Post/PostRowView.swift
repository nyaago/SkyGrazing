//
//  PostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

import SwiftUI

struct PostRowView: View {
    let postContainer: any BskyPostContainable

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                AuthorButtonView(author: postContainer.post.author)
                Spacer()
                CreatedAtText(createdAt: postContainer.post.record.createdAt)
            }
            PostBodyView(post: postContainer.post)
        }
        .padding(.vertical, 4)
    }
}
