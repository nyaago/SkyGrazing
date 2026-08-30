//
//  HeaderTitleModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import Foundation
import SwiftUI

struct HeaderTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.primary)
    }
}
