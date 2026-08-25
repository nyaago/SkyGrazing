//
//  AuthorButtonView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/25.
//

import SwiftUI

private struct ProfileActorKey: EnvironmentKey {
    static let defaultValue: String? = nil
}

extension EnvironmentValues {
    var profileActor: String? {
        get { self[ProfileActorKey.self] }
        set { self[ProfileActorKey.self] = newValue }
    }
}

struct AuthorButtonView: View {
    @Environment(TimelineRouter.self) private var router
    @Environment(\.profileActor) private var profileActor
    let author: BskyProfileViewBasic

    var body: some View {
        Button {
            if author.handle != profileActor {
                router.push(.profile(author))
            }
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
