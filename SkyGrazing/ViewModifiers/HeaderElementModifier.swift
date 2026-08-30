//
//  HeaderElementModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import SwiftUI

struct HeaderElementModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
    }
}
