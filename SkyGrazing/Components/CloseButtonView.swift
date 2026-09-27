//
//  CloseButtonView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/27.
//

import SwiftUI

/// フローティング View などを閉じるためのボタン。
/// タップで渡された action を実行する。見た目は右上に置く想定の xmark アイコン。
struct CloseButtonView: View {
    /// 閉じる操作。
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
    }
}
