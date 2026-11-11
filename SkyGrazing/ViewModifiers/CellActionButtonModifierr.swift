//
//  CellFooterElementViewModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/19.
//

import SwiftUI

struct CellActionButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.primary)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
    }
}
    
