//
//  HeaderModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/30.
//

import Foundation
import SwiftUI

struct HeaderContentsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .foregroundColor(.primary)
    }
}
