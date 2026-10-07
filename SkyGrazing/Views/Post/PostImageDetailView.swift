//
//  PostImageDetailView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/05.
//

import SwiftUI

/// 投稿画像を全画面でポップアップ表示する View。
/// 左上に閉じるボタン、右上に 3 点メニュー（Copy / Save / Share）を配置する。
/// セルで読み込み済みのサムネイル `UIImage`（キャッシュ）を即座に表示しつつ、
/// フルサイズ画像をバックグラウンドで読み込んで差し替える。
struct PostImageDetailView: View {
    let image: BskyImage

    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero

    /// フルサイズ画像の読み込みを管理するローダー。
    @StateObject private var loader = ImageLoader()

    /// 全画面表示に使う URL。フルサイズを優先し、無ければサムネイルを使う。
    private var displayURL: URL? {
        if let fullsize = image.fullsize, let url = URL(string: fullsize) {
            return url
        }
        if let thumb = image.thumb, let url = URL(string: thumb) {
            return url
        }
        return nil
    }

    /// 読み込みに使う URL 文字列。フルサイズを優先する。
    private var loadURLString: String? {
        image.fullsize ?? image.thumb
    }

    /// 表示する画像。フルサイズ読み込み済みならそれを、未完了ならキャッシュ済みサムネイルを使う。
    private var displayImage: UIImage? {
        if let loaded = loader.image {
            return loaded
        }
        if let thumb = image.thumb {
            return ImageCache.shared.image(for: thumb)
        }
        return nil
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                imageContent.background(Color.white)
                    .offset(y: dragOffset.height)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onEnded { value in
                                let threshold: CGFloat = geo.size.height * 0.2
                                // 1/5以上下にドラッグされたら閉じる
                                if value.translation.height > threshold  ||
                                        value.translation.height < -threshold {
                                    dismiss()
                                }
                            }
                    )
                overlayControls
            }
        }
        .task {
            await loader.load(from: loadURLString)
        }
    }

    /// 画面いっぱいに縦横比を維持して表示する画像本体。
    @ViewBuilder
    private var imageContent: some View {
        if let uiImage = displayImage {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if case .failed = loader.state {
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        } else {
            ProgressView()
                .tint(.white)
        }
    }

    /// 左上の閉じるボタンと右上の 3 点メニュー。
    private var overlayControls: some View {
        VStack {
            HStack {
                CloseButtonView { dismiss() }
                Spacer()
                menu
            }
            .padding(.top, 24) // OS の 閉じる / 最小化 / 最大化のボタンと被るので
            .font(.title2)
            .foregroundStyle(.white)
            .padding()
            Spacer()
        }
    }

    /// 右上の 3 点メニュー。
    private var menu: some View {
        Menu {
            Button {
                print("Copy Image: \(displayURL?.absoluteString ?? "-")")
            } label: {
                Label("Copy Image", systemImage: "doc.on.doc")
            }
            Button {
                print("Save Image: \(displayURL?.absoluteString ?? "-")")
            } label: {
                Label("Save Image", systemImage: "square.and.arrow.down")
            }
            Button {
                print("Share: \(displayURL?.absoluteString ?? "-")")
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .foregroundStyle(.secondary)
        }
    }
}
