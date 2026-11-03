//
//  BskyCreateRecordResponse.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/11/03.
//

import Foundation

/// createRecord の応答。成功時は作成されたレコードの uri / cid を含む。
struct BskyCreateRecordResponse: Decodable, BskyResponseCheckable {
    let uri: String?
    let cid: String?

    let error: String?
    let message: String?
    var isError: Bool {
        error != nil
    }
}
