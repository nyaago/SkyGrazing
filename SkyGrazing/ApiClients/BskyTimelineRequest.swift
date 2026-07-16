//
//  BskyTimelineRequest.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/20.
//
// https://docs.bsky.app/docs/api/app-bsky-feed-get-timeline

import Foundation

struct BskyTimelineRequest: BskyRequestable {
    typealias Response = BskyFeedPage

    let algorithm: String?
    let limit: Int?
    let cursor: String?

    init(algorithm: String? = nil, limit: Int? = nil, cursor: String? = nil) {
        self.algorithm = algorithm
        self.limit = limit
        self.cursor = cursor
    }

    func buildQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let algorithm {
            items.append(URLQueryItem(name: "algorithm", value: algorithm))
        }
        if let limit {
            items.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        if let cursor {
            items.append(URLQueryItem(name: "cursor", value: cursor))
        }
        return items
    }

    func endPoint() -> String {
        "app.bsky.feed.getTimeline"
    }
}
