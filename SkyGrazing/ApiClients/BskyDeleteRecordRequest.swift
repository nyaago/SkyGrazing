//
//  BskyDeleteRecordRequest.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/11/11.
//

import Foundation

/// 投稿など任意のレコードを削除する deleteRecord リクエスト。
/// エンドポイント: POST /xrpc/com.atproto.repo.deleteRecord
struct BskyDeleteRecordRequest: BskyPostable {
    typealias Response = BskyDeleteRecordResponse

    /// 削除対象のリポジトリ。投稿者本人の handle または did。
    let repo: String
    /// レコードのコレクション。投稿の場合は "app.bsky.feed.post"。
    let collection: String
    /// 削除対象レコードの rkey（AT URI の末尾）。
    let rkey: String

    /// 投稿を削除する。
    init(repo: String, rkey: String) {
        self.repo = repo
        self.collection = "app.bsky.feed.post"
        self.rkey = rkey
    }

    func endPoint() -> String {
        "com.atproto.repo.deleteRecord"
    }
}
