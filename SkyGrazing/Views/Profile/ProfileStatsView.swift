//
//  ProfileStatsView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import SwiftUI

struct ProfileStatsView: View {
    var profile: BskyProfile?
    /// Followers 数のタップで呼ばれる。フォロワー一覧の表示に使う。
    var onSelectFollowers: () -> Void = {}
    /// Following 数のタップで呼ばれる。フォロー一覧の表示に使う。
    var onSelectFollows: () -> Void = {}

    var body: some View {
        HStack {
            ProfileFollowersView(profile: profile) {
                onSelectFollowers()
            }
            ProfileFollowsView(profile: profile) {
                onSelectFollows()
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
