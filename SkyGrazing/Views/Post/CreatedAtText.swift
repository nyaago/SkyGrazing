//
//  CreatedAtText.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/25.
//

import SwiftUI

struct CreatedAtText: View {
    let createdAt: String?

    var body: some View {
        if let createdAt {
            Text(createdAt).modifier(CaptionModifier())
        }
    }
}
