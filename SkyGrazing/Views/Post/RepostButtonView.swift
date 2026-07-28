//
//  RepostButtonView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/28.
//

import SwiftUI

struct RepostButtonView: View {
    @Environment(TimelineRouter.self) private var router
    let repostAuthor: BskyProfileViewBasic

    var body: some View {
        Button {
            router.push(.profile(repostAuthor))
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.2.squarepath")
                Text("reposted by")
                Text(repostAuthor.displayName ?? repostAuthor.handle)
                    .fontWeight(.semibold)
            }
            .modifier(CaptionModifier())
        }
        .buttonStyle(.plain)
    }
}
