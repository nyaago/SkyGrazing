//
//  ImageLoader.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/08.
//

import SwiftUI

/// 画像をバックグラウンドでダウンロードし、`UIImage` を生成して状態を管理する ObservableObject。
/// 生成した `UIImage` は `ImageCache` に保存し、他の View へ受け渡せるようにする。
@MainActor
final class ImageLoader: ObservableObject {
    /// 読み込みの状態。
    enum LoadState {
        case idle
        case loading
        case loaded(UIImage)
        case failed
    }

    @Published private(set) var state: LoadState = .idle

    /// 読み込み済みの画像。未完了なら nil。
    var image: UIImage? {
        if case .loaded(let image) = state {
            return image
        }
        return nil
    }

    private let cache = ImageCache.shared

    /// 指定した URL 文字列の画像を読み込む。
    /// キャッシュがあれば即座に使用し、無ければバックグラウンドでダウンロードして生成・キャッシュする。
    func load(from urlString: String?) async {
        guard let urlString, let url = URL(string: urlString) else {
            state = .failed
            return
        }

        // キャッシュ済みなら即利用。
        if let cached = cache.image(for: urlString) {
            state = .loaded(cached)
            return
        }

        // 進行中・完了済みは再取得しない。
        switch state {
        case .loading, .loaded:
            return
        default:
            break
        }

        state = .loading

        do {
            // ダウンロードとデコードはバックグラウンドで実行する。
            let image = try await Self.downloadImage(from: url)
            guard let image else {
                state = .failed
                return
            }
            cache.insert(image, for: urlString)
            state = .loaded(image)
        } catch {
            state = .failed
        }
    }

    /// バックグラウンドで画像データを取得し、`UIImage` にデコードする。
    nonisolated private static func downloadImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}
