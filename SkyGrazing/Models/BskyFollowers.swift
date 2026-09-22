//
//  BskyFollowers.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/22.
//

// https://docs.bsky.app/docs/api/app-bsky-graph-get-followers

import Foundation

struct BskyFollowers: Codable, BskyResponseCheckable {
    let subject: BskyProfile
    let cursor: String?
    let followers: [BskyProfile]

    let error: String?
    let message: String?
    var isError: Bool {
        return error != nil
    }
}
