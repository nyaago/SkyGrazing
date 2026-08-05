//
//  PostBodyView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/25.
//

import SwiftUI

struct PostBodyView: View {
    @Environment(TimelineRouter.self) private var router
    let post: BskyPostView

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                router.push(.post(post))
            } label: {
                Text(post.record.text ?? "")
                    .modifier(BodyTextModifier())
            }
            .buttonStyle(.plain)
        }
    }
}
