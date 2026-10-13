//
//  PostExternalView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/13.
//

import SwiftUI

/// 投稿に埋め込まれた外部リンク（記事など）を表示する View。
/// サムネイル画像の上に、ドメインとタイトルを行を分けて表示する。
/// 全体がボタンになっており、タップすると対象 URL をアプリ内の Safari ビューで開く。
struct PostExternalView: View {
    let external: BskyExternalView

    @Environment(\.openURL) private var openURL

    /// サムネイル画像の読み込みを管理するローダー。
    @StateObject private var loader = ImageLoader()

    private let cornerRadius: CGFloat = 10

    var body: some View {
        Button(action: open) {
            VStack(alignment: .leading, spacing: 0) {
                thumbnail
                information
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
        .task {
            await loader.load(from: external.thumb)
        }
    }

    /// サムネイル画像。読み込み状態に応じて表示を切り替える。
    @ViewBuilder
    private var thumbnail: some View {
        if external.thumb != nil {
            Color.clear
                .aspectRatio(1.91, contentMode: .fit)
                .overlay {
                    switch loader.state {
                    case .loaded(let uiImage):
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failed:
                        Color.gray.opacity(0.2)
                    default:
                        Color.gray.opacity(0.1)
                    }
                }
                .clipped()
        }
    }

    /// ドメインとタイトルの表示。行を分けて表示する。
    private var information: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let domain {
                Text(domain)
                    .modifier(CaptionModifier())
            }
            if let title = external.title, !title.isEmpty {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
    }

    /// リンク先 URL のドメイン（先頭の `www.` は除く）。
    private var domain: String? {
        guard let uri = external.uri,
              let host = URL(string: uri)?.host else { return nil }
        return host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
    }

    /// 対象 URL をアプリ内ブラウザで開く。
    private func open() {
        guard let uri = external.uri, let url = URL(string: uri) else { return }
        openURL(url)
    }
}
