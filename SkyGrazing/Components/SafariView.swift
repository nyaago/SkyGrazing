//
//  SafariView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/28.
//

import SwiftUI
import SafariServices

/// `SFSafariViewController` を SwiftUI で使うためのラッパー。
/// 外部 URL をアプリ内の Safari ビューで表示する。`.sheet` などから提示して使う。
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // URL 変更時は新しいインスタンスの提示で対応するため、ここでは何もしない。
    }
}
