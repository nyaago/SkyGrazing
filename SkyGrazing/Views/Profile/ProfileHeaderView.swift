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
                ProfileSectionBarView(selectedSection: $selectedSection)
            }
        }
        .modifier(HeaderContentsModifier())
    }
}

#Preview {
    ProfileHeaderView(selectedSection: .constant(.posts))
}
