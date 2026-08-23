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
            PostHeaderView(postContainer: postContainer)
            PostBodyView(post: postContainer.post)
            PostFooterView(postContainer: postContainer)
        }
        .padding(.vertical, 4)
    }
}
