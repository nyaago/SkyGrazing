//
//  SubHeadlineModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/13.
//

import SwiftUI

struct SubHeadlineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
    }
}
