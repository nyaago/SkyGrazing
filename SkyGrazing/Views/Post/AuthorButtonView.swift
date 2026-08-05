//
//  AuthorButtonView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/25.
//

import SwiftUI

struct AuthorButtonView: View {
    @Environment(TimelineRouter.self) private var router
    let author: BskyProfileViewBasic

    var body: some View {
        Button {
            router.push(.profile(author))
        } label: {
            Text(author.displayName ?? author.handle)
                .modifier(HeadlineModifier())
            Text("@" + author.handle)
                .modifier(CaptionModifier())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
}
