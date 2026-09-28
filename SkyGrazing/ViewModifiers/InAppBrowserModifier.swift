//
//  InAppBrowserModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/28.
//

import SwiftUI

/// 配下のリンク（`.link` 属性やリンク）のタップを横取りし、
/// http/https の URL をアプリ内の Safari ビュー（`SafariView`）で開くようにする Modifier。
/// それ以外のスキームは既定の処理（他アプリ起動など）に委ねる。
private struct InAppBrowserModifier: ViewModifier {
    @State private var browserURL: IdentifiableURL?

    func body(content: Content) -> some View {
        content
            .environment(\.openURL, OpenURLAction { url in
                guard let scheme = url.scheme?.lowercased(),
                      scheme == "http" || scheme == "https" else {
                    return .systemAction
                }
                browserURL = IdentifiableURL(url: url)
                return .handled
            })
            .sheet(item: $browserURL) { item in
                SafariView(url: item.url)
                    .ignoresSafeArea()
            }
    }
}

/// `.sheet(item:)` で扱うための Identifiable な URL ラッパー。
private struct IdentifiableURL: Identifiable {
    let url: URL
    var id: String { url.absoluteString }
}

extension View {
    /// 配下のリンクを、外部ブラウザではなくアプリ内の Safari ビューで開くようにする。
    func openLinksInApp() -> some View {
        modifier(InAppBrowserModifier())
    }
}
