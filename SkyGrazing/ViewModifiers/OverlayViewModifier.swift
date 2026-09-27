//
//  OverlayViewModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/27.
//

import SwiftUI

struct OverlayViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 10)
    }
}
