//
//  ProfileDescriptionView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import SwiftUI

struct ProfileDescriptionView: View {
    var profile: BskyProfile?

    var body: some View {
        HStack {
            Text(description)
                .modifier(BodyTextModifier())
            Spacer()
        }
    }
    
    private var description: String {
        profile?.description ?? "Unknown"
    }
}

#Preview {
    ProfileDescriptionView()
}
