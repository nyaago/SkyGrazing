//
//  TabBarViewModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/01.
//

import SwiftUI

struct TabBarViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
    }
}
