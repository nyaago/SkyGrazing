//
//  BskyRefreshSessionRequest.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/17.
//

import Foundation

/// refreshJwt を使ってセッションを更新し、新しい accessJwt / refreshJwt を取得するリクエスト。
/// 入力パラメータは無く、認証は Authorization ヘッダの refreshJwt で行う。
struct BskyRefreshSessionRequest: BskyPostable {
    typealias Response = BskySession

    func endPoint() -> String {
        "com.atproto.server.refreshSession"
    }
}
