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
            .foregroundColor(.secondary)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 6))
    }
}
    
