//
//  ProfileNameView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import SwiftUI

struct ProfileNameView: View {
    var profile: BskyProfile?

    var body: some View {
        HStack {
            Text(name)
                .modifier(HeaderTitleModifier())
            Spacer()
        }
    }
    
    private var name: String {
        profile?.displayName ?? "Unknown"
    }
}

#Preview {
    ProfileNameView()
}
