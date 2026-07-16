//
//  PostRowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

import SwiftUI

struct PostRowView: View {
    @Environment(TimelineRouter.self) private var router
    let postContainer: any BskyPostContainable

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                authorButton
                Spacer()
                createdAtText
            }
            postButton
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var authorButton: some View {
        Button {
            router.push(.profile(postContainer.post.author))
        } label: {
            Text(postContainer.post.author.displayName ?? postContainer.post.author.handle)
                .modifier(HeadlineModifier())
            Text("@" + postContainer.post.author.handle)
                .modifier(CaptionModifier())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var postButton: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                router.push(.post(postContainer.post))
            } label: {
                Text(postContainer.post.record.text ?? "")
                    .modifier(BodyTextModifier())
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var createdAtText: some View {
        if let createdAt = postContainer.post.record.createdAt {
            Text(createdAt).modifier(CaptionModifier())
        }
    }
}
