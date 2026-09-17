//
//  MenuView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/17.
//

import SwiftUI

/// 左からスライドして出現するメニュー。
/// 最初はオフセットをメニュー幅分マイナスして非表示にしておき、
/// DragGesture でオフセットを変更して表示/非表示を切り替える。
struct MenuView: View {
    private enum Layout {
        /// メニューの幅
        static let menuWidth: CGFloat = 270
        /// 閉じているときに左端からのドラッグを検知する透明ストリップの幅
        static let edgeWidth: CGFloat = 24
    }

    /// メニュー本体の現在のオフセット。非表示時は -menuWidth。
    @State private var offset: CGFloat = -Layout.menuWidth
    /// ドラッグ確定後のオフセット。ドラッグ中の起点として使う。
    @State private var committedOffset: CGFloat = -Layout.menuWidth
    
    var body: some View {
        // メニューが開いている割合（0: 非表示, 1: 全表示）
        let progress = Double((offset + Layout.menuWidth) / Layout.menuWidth)
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 開いているときの背景。タップで閉じる。
                if progress > 0 {
                    Color.black
                        .opacity(0.3 * progress)
                        .ignoresSafeArea()
                        .onTapGesture { close() }
                }
                
                // 閉じているときに左端からのドラッグを検知する透明ストリップ
                if progress <= 0 {
                    Color.clear
                        .frame(width: Layout.edgeWidth)
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .gesture(dragGesture)
                }
                
                // メニュー本体
                menuContent
                    .frame(width: Layout.menuWidth)
                    .frame(maxHeight: .infinity)
                    .background(.regularMaterial)
                    .offset(x: offset)
                    .gesture(dragGesture)
            }
        }
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

    /// メニューのオフセットを変更するドラッグ操作。
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let proposed = committedOffset + value.translation.width
                offset = min(0, max(-Layout.menuWidth, proposed))
            }
            .onEnded { _ in
                // ドラッグ量が半分を超えていれば開く、そうでなければ閉じる。
                withAnimation(.easeOut(duration: 0.25)) {
                    offset = offset > -Layout.menuWidth / 2 ? 0 : -Layout.menuWidth
                }
                committedOffset = offset > -Layout.menuWidth / 2 ? 0 : -Layout.menuWidth
            }
    }

    /// メニューを閉じる。
    private func close() {
        withAnimation(.easeOut(duration: 0.25)) {
            offset = -Layout.menuWidth
        }
        committedOffset = -Layout.menuWidth
    }
}

#Preview {
    MenuView()
}
