//
//  ProfileHandleView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import SwiftUI

struct ProfileHandleView: View {
    var profile: BskyProfile?

    var body: some View {
        HStack {
            Text(handle)
                .modifier(CaptionModifier())
            Spacer()
        }
    }
    
    private var handle: String {
        profile?.handle ?? "Unknown"
    }
}

#Preview {
    ProfileHandleView()
}
