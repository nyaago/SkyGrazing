//
//  ProfileAvatarView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/27.
//

import SwiftUI

/// アカウントのアバター画像を円形で表示する View。
/// 画像 URL がない場合はグレーのプレースホルダーを表示する。
struct ProfileAvatarView: View {
    let avatar: String?
    var size: CGFloat = 40

    var body: some View {
        Group {
            if let avatar, let url = URL(string: avatar) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                }
            } else {
                Color.gray
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white.opacity(0.15)))
    }
}
