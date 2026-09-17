//
//  MenuView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/17.
//

import SwiftUI

/// 左からスライドして出現するメニュー。
/// 幅(width)と表示位置(offset)は呼び出し側から渡され、DragGesture 等の操作も呼び出し側で行う。
/// 非表示時は offset を -width にしておく。
struct MenuView: View {
    /// メニューの幅
    let width: CGFloat

    /// メニュー本体の現在のオフセット。非表示時は -width。
    let offset: CGFloat

    var body: some View {
        menuContent
            .frame(width: width)
            .frame(maxHeight: .infinity)
            .background(.regularMaterial)
            .offset(x: offset)
    }

    /// メニュー内のコンテンツ。一番下に Sign Out ボタンを配置する。
    private var menuContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            Divider()

            Button(role: .destructive) {
                // TODO: サインアウト処理は後で実装する
            } label: {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    .font(.headline)
                    .padding(.vertical, 12)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MenuView(width: 270, offset: 0)
}
