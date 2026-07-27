//
//  CurrentPostBodyView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/27.
//

import SwiftUI

struct CurrentPostBodyView: View {
    let post: BskyPostView

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(post.record.text ?? "")
                .modifier(BodyTextModifier())
        }
    }
}
