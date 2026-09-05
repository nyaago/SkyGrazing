//
//  ProfileCreatedAtView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/01.
//

import SwiftUI

struct ProfileCreatedAtView: View {
    var profile: BskyProfile?

    var body: some View {
        HStack {
            Text(joinedText)
                .modifier(CaptionModifier())
            Spacer()
        }
    }

    private var joinedText: String {
        guard let createdAt = profile?.createdAt else {
            return ""
        }
        let monthAndDay = AbsoluteDateFormatter.monthAndDay(from: createdAt)
        return "Joined \(monthAndDay)"
    }
}

#Preview {
    ProfileCreatedAtView()
}
