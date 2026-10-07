//
//  ImageCache.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/08.
//

import UIKit

/// ダウンロード済みの `UIImage` を URL 文字列をキーにキャッシュする共有ストア。
/// モデル層で画像を保持し、サムネイル表示（セル）と全画面表示（詳細）で使い回す。
final class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    /// キャッシュから画像を取得する。無ければ nil。
    func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    /// 画像をキャッシュに保存する。
    func insert(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
