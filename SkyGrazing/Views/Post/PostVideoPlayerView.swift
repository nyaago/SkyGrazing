//
//  PostVideoPlayerView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/10/19.
//

import AVKit
import SwiftUI

/// 投稿に埋め込まれた動画（app.bsky.embed.video#view）を再生する View。
/// HLS プレイリスト（.m3u8）を AVKit の `VideoPlayer` で再生する。
struct PostVideoPlayerView: View {
    let video: BskyVideo

    /// 再生に使用するプレイヤー。プレイリスト URL から生成する。
    @State private var player: AVPlayer?

    private let cornerRadius: CGFloat = 10

    var body: some View {
        Group {
            if let player {
                VideoPlayer(player: player)
                    .aspectRatio(aspectRatio, contentMode: .fit)
            } else {
                // プレイリスト URL が無効な場合のプレースホルダー。
                Color.gray.opacity(0.1)
                    .aspectRatio(aspectRatio, contentMode: .fit)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        .onAppear {
            guard player == nil,
                  let playlist = video.playlist,
                  let url = URL(string: playlist) else { return }
            player = AVPlayer(url: url)
        }
    }

    /// 動画の縦横比。情報が無い場合は 16:9 を既定とする。
    private var aspectRatio: CGFloat {
        guard let ratio = video.aspectRatio, ratio.height > 0 else {
            return 16.0 / 9.0
        }
        return CGFloat(ratio.width) / CGFloat(ratio.height)
    }
}
