//
//  ProfileHeaderView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/24.
//

import SwiftUI

struct ProfileHeaderView: View {
    var profile: BskyProfile?
    @Binding var selectedTab: ProfileTab
    // ...
    
    var body: some View {
        VStack {
            if let profile  {
                ProfileNameView(profile: profile)
                    .modifier(HeaderElementModifier())
                ProfileHandleView(profile: profile)
                    .modifier(HeaderElementModifier())
                ProfileStatsView(profile: profile)
                    .modifier(HeaderElementModifier())
                ProfileDescriptionView(profile: profile)
                    .modifier(HeaderElementModifier())
                ProfileCreatedAtView(profile: profile)
                ProfileTabBarView(selectedTab: $selectedTab)
            }
        }
        .modifier(HeaderContentsModifier())
    }
}

#Preview {
    ProfileHeaderView(selectedTab: .constant(.posts))
}
