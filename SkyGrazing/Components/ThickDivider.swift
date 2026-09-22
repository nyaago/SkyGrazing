//
//  ThickDivider.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/22.
//

import SwiftUI

struct ThickDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color(.separator))
            .frame(height: 2) // 標準の1ptより太め
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical)
    }
}

#Preview {
    ThickDivider()
}
