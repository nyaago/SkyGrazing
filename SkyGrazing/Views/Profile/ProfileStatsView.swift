//
//  ProfileStatsView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import SwiftUI

struct ProfileStatsView: View {
    var profile: BskyProfile?

    var body: some View {
        HStack {
            ProfileFollowersView(profile: profile) {
                // TODO: navigation
            }
            ProfileFollowsView(profile: profile) {
                // TODO: navigation
            }
            ProfilePostsView(profile: profile) {
                // TODO: navigation
            }
            Spacer()
        }
    }
}

#Preview {
    ProfileStatsView()
}
