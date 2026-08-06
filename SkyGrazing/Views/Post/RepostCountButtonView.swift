//
//  RepostCountButtonView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct RepostCountButtonView: View {
    let repostCount: Int

    var body: some View {
        Button {
            print("reply count tapped")
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.2.squarepath")
                Text("\(repostCount)")
            }
            .modifier(CaptionModifier())
        }
        .buttonStyle(.plain)
    }
}
