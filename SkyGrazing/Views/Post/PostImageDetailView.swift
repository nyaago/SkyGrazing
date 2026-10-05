//
//  PostImageDetailView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/05.
//

import SwiftUI

/// 投稿画像を全画面でポップアップ表示する View。
/// 左上に閉じるボタン、右上に 3 点メニュー（Copy / Save / Share）を配置する。
struct PostImageDetailView: View {
    let image: BskyImage

    @Environment(\.dismiss) private var dismiss

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

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            imageContent

            overlayControls
        }
    }

    /// 画面いっぱいに縦横比を維持して表示する画像本体。
    @ViewBuilder
    private var imageContent: some View {
        if let url = displayURL {
            AsyncImage(url: url) { phase in
                switch phase {
                    case .success(let loaded):
                        loaded
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    default:
                        ProgressView()
                            .tint(.white)
                }
            }
        } else {
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
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
