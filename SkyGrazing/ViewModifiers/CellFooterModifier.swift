//
//  CellFooterModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct CellFooterModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 6, leading: 0, bottom: 2, trailing: 0))
    }
}

