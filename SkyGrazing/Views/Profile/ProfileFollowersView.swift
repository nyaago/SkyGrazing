//
//  ProfileFollowersView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import SwiftUI

struct ProfileFollowersView: View {
    var profile: BskyProfile?
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text("\(followersCount) followers")
                .modifier(CellActionButtonModifier())
        }
    }

    private var followersCount: Int {
        profile?.followersCount ?? 0
    }
}

#Preview {
    ProfileFollowersView()
}
