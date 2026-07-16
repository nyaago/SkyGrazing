//
//  BskyAuthorFeedRequest.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/07.
//

// https://docs.bsky.app/docs/api/app-bsky-feed-get-author-feed

import Foundation

struct BskyAuthorFeedRequest: BskyRequestable {
    typealias Response = BskyFeedPage

    let actor: String
    let limit: Int?
    let cursor: String?
    let filter: String?

    init(actor: String, limit: Int? = nil, cursor: String? = nil, filter: String? = nil) {
        self.actor = actor
        self.limit = limit
        self.cursor = cursor
        self.filter = filter
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
        if let filter {
            items.append(URLQueryItem(name: "filter", value: filter))
        }
        return items
    }

    func endPoint() -> String {
        "app.bsky.feed.getAuthorFeed"
    }
}
