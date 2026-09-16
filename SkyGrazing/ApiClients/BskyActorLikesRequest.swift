//
//  BskyActorLikesRequest.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/16.
//

// https://docs.bsky.app/docs/api/app-bsky-feed-get-actor-likes

import Foundation

struct BskyActorLikesRequest: BskyRequestable {
    typealias Response = BskyFeedPage

    let actor: String
    let limit: Int?
    let cursor: String?

    init(actor: String, limit: Int? = nil, cursor: String? = nil) {
        self.actor = actor
        self.limit = limit
        self.cursor = cursor
    }

    func buildQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "actor", value: actor)
        ]
        if let limit {
            items.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        if let cursor {
            items.append(URLQueryItem(name: "cursor", value: cursor))
        }
        return items
    }

    func endPoint() -> String {
        "app.bsky.feed.getActorLikes"
    }
}
