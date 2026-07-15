//
//  BskyTimeline.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/20.
//

// https://docs.bsky.app/docs/api/app-bsky-feed-get-timeline

import Foundation

struct BskyFeed: Codable, BskyResponseCheckable {
    let cursor: String?
    let feed: [BskyFeedViewPost]?

    let error: String?
    let message: String?
    var isError: Bool {
        return error != nil
    }
}

// MARK: - app.bsky.feed.defs#feedViewPost

struct BskyFeedViewPost: Codable {
    let post: BskyPostView
    let reply: BskyReplyRef?
    let reason: BskyReasonRepost?
    let feedContext: String?
}

// MARK: - app.bsky.feed.defs#postView

struct BskyPostView: Codable, Hashable {
    let uri: String
    let cid: String
    let author: BskyProfileViewBasic
    let record: BskyPostRecord
    let replyCount: Int?
    let repostCount: Int?
    let likeCount: Int?
    let quoteCount: Int?
    let indexedAt: String?
    let labels: [BskyLabel]?

    func hash(into hasher: inout Hasher) {
        hasher.combine(cid)
    }

    static func == (lhs: BskyPostView, rhs: BskyPostView) -> Bool {
        lhs.cid == rhs.cid
    }
}

// MARK: - app.bsky.feed.post (record)

struct BskyPostRecord: Codable {
    let type: String?
    let text: String?
    let createdAt: String?
    let langs: [String]?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case text
        case createdAt
        case langs
    }
}

// MARK: - app.bsky.feed.defs#replyRef

struct BskyReplyRef: Codable {
    let root: BskyPostView?
    let parent: BskyPostView?
    let grandparentAuthor: BskyProfileViewBasic?
}

// MARK: - app.bsky.feed.defs#reasonRepost / reasonPin
// lexicon defines the metadata used in Bluesky feeds to indicate that a post appears
//   because someone you follow reposted it. It contains the reposter’s profile info,
//   the repost's URI/CID, and the timestamp
struct BskyReasonRepost: Codable {
    let type: String?
    let by: BskyProfileViewBasic?
    let indexedAt: String?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case by
        case indexedAt
    }
}
