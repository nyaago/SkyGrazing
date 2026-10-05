//
//  PostImageView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/01.
//

import SwiftUI

/// 投稿に添付された画像 1 枚を表示する View。
/// タップ操作のためボタンとして実装している。
struct PostImageView: View {
    let image: BskyImage
    /// 画像の表示方法。正方形トリミング時は `.fill`、
    /// 縦横比を維持して収める場合は `.fit` を指定する。
    var contentMode: ContentMode = .fill

    var body: some View {
        if let urlString = image.thumb, let url = URL(string: urlString) {
            Button(action: {
                print("tapped image at url :\(url)")
            }) {
                AsyncImage(url: url) { phase in
                    switch phase {
                        case .success(let loaded):
                            loaded
                                .resizable()
                                .aspectRatio(contentMode: contentMode)
                        case .failure:
                            Color.gray.opacity(0.2)
                        default:
                            Color.gray.opacity(0.1)
                    }
                }
            }
            .buttonStyle(.plain)

        } else {
            Color.gray.opacity(0.2)
        }
    }
}
