//
//  ReplyToView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/27.
//

import SwiftUI

struct ReplyToButtonView: View {
    @Environment(TimelineRouter.self) private var router
    let parentAuthor: BskyProfileViewBasic

    var body: some View {
        Button {
            router.push(.profile(parentAuthor))
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrowshape.turn.up.left")
                Text("replying to")
                Text(parentAuthor.displayName ?? parentAuthor.handle)
                    .fontWeight(.semibold)
            }
            .modifier(CellActionButtonModifier())
        }
        .buttonStyle(.plain)
    }
}
