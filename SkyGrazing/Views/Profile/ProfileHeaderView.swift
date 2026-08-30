//
//  ProfileHeaderView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/24.
//

import SwiftUI

struct ProfileHeaderView: View {
    var profile: BskyProfile?
    
    var body: some View {
        VStack {
            VStack {
                if let profile  {
                    ProfileNameView(profile: profile)
                        .modifier(HeaderElementModifier())
                    ProfileHandleView(profile: profile)
                        .modifier(HeaderElementModifier())
                    ProfileDescriptionView(profile: profile)
                        .modifier(HeaderElementModifier())
                }
            }
            .modifier(HeaderContentsModifier())
        }
    }
}

#Preview {
    ProfileHeaderView()
}
