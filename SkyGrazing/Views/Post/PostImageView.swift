//
//  PostImageView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/01.
//

import SwiftUI

/// 投稿に添付された画像 1 枚を表示する View。
/// タップ操作のためボタンとして実装している。
/// 画像は `ImageLoader` がバックグラウンドで読み込み、生成した `UIImage` を表示する。
struct PostImageView: View {
    let image: BskyImage
    /// 画像の表示方法。正方形トリミング時は `.fill`、
    /// 縦横比を維持して収める場合は `.fit` を指定する。
    var contentMode: ContentMode = .fill

    /// サムネイル画像の読み込みを管理するローダー。
    @StateObject private var loader = ImageLoader()

    /// 全画面ポップアップの表示状態。
    @State private var isPresentingDetail = false

    var body: some View {
        if image.thumb != nil {
            Button(action: {
                isPresentingDetail = true
            }) {
                content
            }
            .buttonStyle(.plain)
            .task {
                await loader.load(from: image.thumb)
            }
            .fullScreenCover(isPresented: $isPresentingDetail) {
                PostImageDetailView(image: image)
            }
        } else {
            Color.gray.opacity(0.2)
        }
    }

    /// 読み込み状態に応じた表示内容。
    @ViewBuilder
    private var content: some View {
        switch loader.state {
        case .loaded(let uiImage):
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        case .failed:
            Color.gray.opacity(0.2)
        default:
            Color.gray.opacity(0.1)
        }
    }
}
