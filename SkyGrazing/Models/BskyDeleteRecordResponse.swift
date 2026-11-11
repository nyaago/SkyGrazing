//
//  BskyDeleteRecordResponse.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/11/11.
//

import Foundation

/// deleteRecord の応答。成功時はコミット情報を含む（省略される場合もある）。
struct BskyDeleteRecordResponse: Decodable, BskyResponseCheckable {
    let commit: Commit?

    let error: String?
    let message: String?
    var isError: Bool {
        error != nil
    }

    /// 削除をコミットしたリポジトリの状態。
    struct Commit: Decodable {
        let cid: String?
        let rev: String?
    }
}
