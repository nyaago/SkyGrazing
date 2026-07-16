//
//  BskyThread.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

// https://docs.bsky.app/docs/api/app-bsky-feed-get-post-thread

import Foundation

struct BskyThread: Codable, BskyResponseCheckable {
    let thread: BskyThreadViewPost?

    let error: String?
    let message: String?
    var isError: Bool {
        return error != nil
    }
}

// MARK: - app.bsky.feed.defs#threadViewPost
// class を使用: parent / replies が再帰的な構造のため

class BskyThreadViewPost: Codable {
    let post: BskyPostView
    let parent: BskyThreadViewPost?
    let replies: [BskyThreadViewPost]?
}
