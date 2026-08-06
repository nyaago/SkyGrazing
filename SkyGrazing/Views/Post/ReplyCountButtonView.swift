//
//  ReplyCountButtonView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct ReplyCountButtonView: View {
    let replyCount: Int

    var body: some View {
        Button {
            print("reply count tapped")
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                Text("\(replyCount)")
            }
            .modifier(CaptionModifier())
        }
        .buttonStyle(.plain)
    }
}
