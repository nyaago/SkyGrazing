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
            }
            CurrentPostBodyView(post: postContainer.post)
            CurrentPostFooterView(postContainer: postContainer)
        }
        .padding(.vertical, 4)
    }
}
