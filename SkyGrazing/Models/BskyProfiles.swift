//
//  BskyProfiles.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/25.
//

import Foundation

// https://docs.bsky.app/docs/api/app-bsky-actor-get-profiles

struct BskyProfiles: Codable, BskyResponseCheckable {
    let profiles: [BskyProfile]

    let error: String?
    let message: String?
    var isError: Bool {
        return error != nil
    }
}
