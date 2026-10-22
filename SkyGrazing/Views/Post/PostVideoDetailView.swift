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
        ZStack {
            Color.black.ignoresSafeArea()

            VideoPlayer(player: player)
                .ignoresSafeArea()

            overlayControls
        }
        .onAppear {
            // 共有プレイヤーの現在位置からそのまま再生を続ける。
            //player.play()
            if !player.currentTime().isValid {
                player.seek(to: .zero)
            }
        }
    }

    /// 左上の閉じるボタン。
    private var overlayControls: some View {
        VStack {
            HStack {
                CloseButtonView { dismiss() }
                Spacer()
            }
            .padding(.top, 24) // OS の 閉じる / 最小化 / 最大化のボタンと被るので
            .font(.title2)
            .foregroundStyle(.white)
            .padding()
            Spacer()
        }
    }
}
