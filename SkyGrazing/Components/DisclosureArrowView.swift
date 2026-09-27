//
//  DisclosureArrowView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/27.
//

import SwiftUI

/// セル右端に表示する遷移用の矢印（chevron）。
/// タップで別画面へ遷移する行の視覚的な手がかりとして使う。
struct DisclosureArrowView: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.footnote)
            .foregroundColor(.gray)
    }
}
