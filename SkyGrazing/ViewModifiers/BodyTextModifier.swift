//
//  BodyTextModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

import Foundation
import SwiftUI

struct BodyTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(.primary)
    }
}
