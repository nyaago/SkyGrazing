//
//  PostVideoDetailView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/22.
//

import AVKit
import SwiftUI

/// 投稿動画を全画面でポップアップ表示する View。
/// 左上に閉じるボタンを配置し、表示時に自動再生する。
/// `PostImageDetailView` と同様のレイアウトで黒背景の上に動画を表示する。
///
/// インラインの `PostVideoPlayerView` と同一の `AVPlayer` を共有することで、
/// 再生位置・再生状態を双方向で引き継ぐ。
struct PostVideoDetailView: View {
    /// インラインのセルと共有する再生プレイヤー。
    let player: AVPlayer

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                VideoPlayer(player: player)
                    .frame(height: videoPlayerHeight(geometry: geo))

                overlayControls
                    .frame(height: videoPlayerHeight(geometry: geo))
            }
            .onAppear {
            }

        }
    }

    private func safeAreaHeight(geometry: GeometryProxy) -> CGFloat {
        return geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
    }
    
    private func videoPlayerHeight(geometry: GeometryProxy) -> CGFloat {
        let totalSafeAreaHeight = safeAreaHeight(geometry: geometry)
        return geometry.size.height - totalSafeAreaHeight * 2
    }
    
    /// 左上の閉じるボタン。
    private var overlayControls: some View {
        VStack {
            HStack {
                CloseButtonView { dismiss() }
                Spacer()
            }
            .font(.title2)
            .foregroundStyle(.white)
            .padding(.leading, 64) // Video Player の 音声取得Controlがあるので
            Spacer()
        }
    }
}
