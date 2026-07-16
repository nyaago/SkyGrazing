//
//  CaptionModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

import Foundation
import SwiftUI

struct CaptionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.secondary)
    }
}
