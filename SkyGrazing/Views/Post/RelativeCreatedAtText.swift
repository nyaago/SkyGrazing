//
//  RelativeCreatedAtText.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct RelativeCreatedAtText: View {
    let createdAt: String?

    var body: some View {
        Text(formattedText).modifier(CaptionModifier())
    }

    private var formattedText: String {
        if let createdAt {
            return RelativeDateFormatter.string(from: createdAt) ?? ""
        }
        return ""
    }
}

/*
 #Preview {
 RelativeCreatedAtText()
 }
 */
