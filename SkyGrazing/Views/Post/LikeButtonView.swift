//
//  LikeButtonView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct LikeButtonView: View {
    let likeCount: Int

    var body: some View {
        Button {
            print("like tapped")
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "heart")
                Text("\(likeCount)")
            }
            .modifier(CellActionButtonModifier())
        }
        .buttonStyle(.plain)
    }
}
