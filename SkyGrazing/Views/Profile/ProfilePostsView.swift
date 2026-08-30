//
//  ProfilePostsView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import SwiftUI

struct ProfilePostsView: View {
    var profile: BskyProfile?
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text("\(postsCount) posts")
                .modifier(CellActionButtonModifier())
        }
    }

    private var postsCount: Int {
        profile?.postCount ?? 0
    }
}

#Preview {
    ProfilePostsView()
}
