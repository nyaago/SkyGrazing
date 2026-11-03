//
//  BskyCreateRecordRequest.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/11/03.
//

import Foundation

/// 投稿など任意のレコードを作成する createRecord リクエスト。
/// エンドポイント: POST /xrpc/com.atproto.repo.createRecord
struct BskyCreateRecordRequest: BskyPostable {
    typealias Response = BskyCreateRecordResponse

    /// 投稿先のリポジトリ。ユーザーの handle または did。
    let repo: String
    /// レコードのコレクション。投稿の場合は "app.bsky.feed.post"。
    let collection: String
    /// 投稿レコード本体。
    let record: PostRecord

    /// テキスト投稿を生成する。
    init(repo: String, text: String, createdAt: Date = Date()) {
        self.repo = repo
        self.collection = "app.bsky.feed.post"
        self.record = PostRecord(text: text, createdAt: Self.iso8601String(from: createdAt))
    }

    func endPoint() -> String {
        "com.atproto.repo.createRecord"
    }

    /// app.bsky.feed.post レコード。
    struct PostRecord: Encodable {
        let type = "app.bsky.feed.post"
        let text: String
        let createdAt: String

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case text
            case createdAt
        }
    }

    /// createdAt 用に小数秒付き ISO8601 文字列へ変換する。
    private static func iso8601String(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
}
