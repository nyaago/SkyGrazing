//
//  BskyPostThreadRequest.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

// https://docs.bsky.app/docs/api/app-bsky-feed-get-post-thread

import Foundation

struct BskyPostThreadRequest: BskyRequestable {
    typealias Response = BskyThread

    let uri: String
    let depth: Int?
    let parentHeight: Int?

    init(uri: String, depth: Int? = nil, parentHeight: Int? = nil) {
        self.uri = uri
        self.depth = depth
        self.parentHeight = parentHeight
    }

    func buildQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "uri", value: uri)
        ]
        if let depth {
            items.append(URLQueryItem(name: "depth", value: String(depth)))
        }
        if let parentHeight {
            items.append(URLQueryItem(name: "parentHeight", value: String(parentHeight)))
        }
        return items
    }

    func endPoint() -> String {
        "app.bsky.feed.getPostThread"
    }
}
