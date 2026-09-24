//
//  ProfileHeaderView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/24.
//

import SwiftUI

struct ProfileHeaderView: View {
    var profile: BskyProfile?
    @Binding var selectedSection: ProfileSection
    /// Followers 数のタップで呼ばれる。フォロワー一覧の表示に使う。
    var onSelectFollowers: () -> Void = {}
    // ...

    var body: some View {
        VStack {
            if let profile  {
                ProfileNameView(profile: profile)
                    .modifier(HeaderElementModifier())
                ProfileHandleView(profile: profile)
                    .modifier(HeaderElementModifier())
                ProfileStatsView(profile: profile, onSelectFollowers: onSelectFollowers)
                    .modifier(HeaderElementModifier())
                ProfileDescriptionView(profile: profile)
                    .modifier(HeaderElementModifier())
                ProfileCreatedAtView(profile: profile)
                ProfileSectionBarView(selectedSection: $selectedSection,
                                      sections: sections(for: profile))
            }
        }
        .modifier(HeaderContentsModifier())
    }

    /// Likes セクションはログイン中の本人のプロフィールの場合のみ表示する
    private func sections(for profile: BskyProfile) -> [ProfileSection] {
        let isOwner = profile.handle == UserSettings.handle
        return ProfileSection.allCases.filter { $0 != .likes || isOwner }
    }
}

#Preview {
    ProfileHeaderView(selectedSection: .constant(.posts))
}
