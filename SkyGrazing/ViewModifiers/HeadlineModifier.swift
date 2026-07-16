//
//  HeadlineModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

import Foundation
import SwiftUI

struct HeadlineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.primary)
    }
}
