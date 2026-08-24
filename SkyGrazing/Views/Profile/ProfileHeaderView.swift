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
            if let profile  {
                Text(profile.displayName ?? UserSettings.handle)
                    .font(.largeTitle)
                Text(profile.description ?? "")
            }
        }
    }
}

#Preview {
    ProfileHeaderView()
}
