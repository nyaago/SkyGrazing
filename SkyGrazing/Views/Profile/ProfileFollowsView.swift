//
//  ProfileFollowsView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import SwiftUI

struct ProfileFollowsView: View {
    var profile: BskyProfile?
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text("\(followsCount) following")
                .modifier(CellActionButtonModifier())
        }
    }

    private var followsCount: Int {
        profile?.followsCount ?? 0
    }
}

#Preview {
    ProfileFollowsView()
}
