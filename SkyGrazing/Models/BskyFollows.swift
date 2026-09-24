//
//  BskyFollows.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/22.
//

// https://docs.bsky.app/docs/api/app-bsky-graph-get-follows

import Foundation

struct BskyFollows: Codable, BskyResponseCheckable {
    let subject: BskyProfile
    let cursor: String?
    let follows: [BskyProfile]

    let error: String?
    let message: String?
    var isError: Bool {
        return error != nil
    }
}
