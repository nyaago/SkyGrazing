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
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                VideoPlayer(player: player)
                    .frame(height: videoPlayerHeight(geometry: geo))
                    .offset(y: videoOffset)

                overlayControls
                    .frame(height: videoPlayerHeight(geometry: geo))
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        let threshold: CGFloat = geo.size.height * 0.2
                        // 1/5以上上下にドラッグされたら閉じる
                        if value.translation.height > threshold ||
                                value.translation.height < -threshold {
                            dismiss()
                        }
                    }
            )
            .onAppear {
            }

        }
    }
    
    private var videoOffset: CGFloat {
        return dragOffset.height
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
