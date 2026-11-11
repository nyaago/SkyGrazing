//
//  PostMenuButtonView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/11/11.
//

import SwiftUI

/// 投稿フッターの三点( … )メニュー。
/// 自分の投稿にのみ表示し、Delete Post 項目を持つ。
struct PostMenuButtonView: View {
    var body: some View {
        Menu {
            Button(role: .destructive) {
                // TODO: 投稿削除の実装（現状はダミー）
                print("delete post tapped")
            } label: {
                Label("Delete Post", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .modifier(CellActionButtonModifier())
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
