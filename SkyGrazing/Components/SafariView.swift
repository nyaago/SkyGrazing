//
//  SafariView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/28.
//

import SwiftUI
import SafariServices

/// `SFSafariViewController` を SwiftUI で使うためのラッパー。
/// 外部 URL をアプリ内の Safari ビューで表示する。`.sheet` / `.fullScreenCover` などから提示して使う。
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    /// Safari の「完了」ボタンなどで閉じられたときに呼ばれる。
    var onFinish: () -> Void = {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onFinish: onFinish)
    }

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // URL 変更時は新しいインスタンスの提示で対応するため、ここでは何もしない。
    }

    final class Coordinator: NSObject, SFSafariViewControllerDelegate {
        private let onFinish: () -> Void

        init(onFinish: @escaping () -> Void) {
            self.onFinish = onFinish
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            onFinish()
        }
    }
}
