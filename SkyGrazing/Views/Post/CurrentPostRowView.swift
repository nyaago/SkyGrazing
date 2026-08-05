//
//  CurrentPostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/27.
//

import SwiftUI

struct CurrentPostRowView: View {
    let postContainer: any BskyPostContainable

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                AuthorButtonView(author: postContainer.post.author)
                Spacer()
                CreatedAtText(createdAt: postContainer.post.record.createdAt)
            }
            CurrentPostBodyView(post: postContainer.post)
        }
        .padding(.vertical, 4)
    }
}
