//
//  PostImagesView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/01.
//

import SwiftUI

/// 投稿に添付された画像を、枚数に応じたレイアウトで表示する View。
/// - 1 枚: 縦横比を維持して大きく表示
/// - 2 枚: 左右 50% ずつ、正方形トリミングで横並び
/// - 3 枚: 左に大きめの正方形、右に小さな正方形 2 枚を縦積み
/// - 4 枚: 田の字型（2×2）の正方形で 4 分割
struct PostImagesView: View {
    let images: [BskyImage]

    private let spacing: CGFloat = 3
    private let cornerRadius: CGFloat = 10

    var body: some View {
        Group {
            switch images.count {
            case 0:
                EmptyView()
            case 1:
                singleLayout
            case 2:
                doubleLayout
            case 3:
                tripleLayout
            default:
                quadLayout
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    // MARK: - レイアウト

    /// 1 枚: 縦横比を維持して大きく表示。
    private var singleLayout: some View {
        let ratio = aspectRatio(of: images[0]) ?? (4.0 / 3.0)
        return imageCell(images[0])
            .aspectRatio(ratio, contentMode: .fit)
    }

    /// 2 枚: 左右 50% ずつ、正方形トリミングで横並び。
    private var doubleLayout: some View {
        HStack(spacing: spacing) {
            imageCell(images[0])
            imageCell(images[1])
        }
        .aspectRatio(2, contentMode: .fit)
    }

    /// 3 枚: 左に大きめの正方形、右に小さな正方形 2 枚を縦積み。
    private var tripleLayout: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let leftSide = (2 * width - spacing) / 3
            let rightSide = (width - 2 * spacing) / 3
            HStack(spacing: spacing) {
                imageCell(images[0])
                    .frame(width: leftSide, height: leftSide)
                VStack(spacing: spacing) {
                    imageCell(images[1])
                        .frame(width: rightSide, height: rightSide)
                    imageCell(images[2])
                        .frame(width: rightSide, height: rightSide)
                }
            }
        }
        // 全体を横:縦 = 3:2 にすると左の正方形が全高に収まる。
        .aspectRatio(3.0 / 2.0, contentMode: .fit)
    }

    /// 4 枚: 田の字型（2×2）の正方形で 4 分割。
    private var quadLayout: some View {
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                imageCell(images[0])
                imageCell(images[1])
            }
            HStack(spacing: spacing) {
                imageCell(images[2])
                imageCell(images[3])
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    // MARK: - ヘルパー

    /// 与えられた領域いっぱいに画像を敷き詰めてトリミングするセル。
    private func imageCell(_ image: BskyImage) -> some View {
        Color.clear
            .overlay {
                PostImageView(image: image)
            }
            .clipped()
            .contentShape(Rectangle())
    }

    /// 画像の縦横比（幅 / 高さ）。取得できない場合は nil。
    private func aspectRatio(of image: BskyImage) -> CGFloat? {
        guard let ratio = image.aspectRatio, ratio.height > 0 else { return nil }
        return CGFloat(ratio.width) / CGFloat(ratio.height)
    }
}
