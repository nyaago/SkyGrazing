//
//  BskyProfileListResponse.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/24.
//

import Foundation

/// プロフィールの一覧をページングで返すレスポンスの共通インターフェース。
/// フォロワー / フォロー一覧のように、配列のキー名は異なるが
/// 要素の型 (`BskyProfile`) と cursor ページングが共通のレスポンスを統一して扱うために使う。
protocol BskyProfileListResponse: BskyResponseCheckable {
    var profiles: [BskyProfile] { get }
    var cursor: String? { get }
}

extension BskyFollowers: BskyProfileListResponse {
    var profiles: [BskyProfile] { followers }
}

extension BskyFollows: BskyProfileListResponse {
    var profiles: [BskyProfile] { follows }
}
