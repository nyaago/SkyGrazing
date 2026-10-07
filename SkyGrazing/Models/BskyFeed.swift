//
//  BskyTimeline.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/20.
//

// https://docs.bsky.app/docs/api/app-bsky-feed-get-timeline

import Foundation

struct BskyFeedPage: Codable, BskyResponseCheckable {
    let cursor: String?
    let feed: [BskyFeedViewPost]?

    let error: String?
    let message: String?
    var isError: Bool {
        return error != nil
    }
}

// MARK: - BskyPostContainable

protocol BskyPostContainable {
    var post: BskyPostView { get }
}

// MARK: - app.bsky.feed.defs#feedViewPost

struct BskyFeedViewPost: Codable, BskyPostContainable {
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
    let embed: BskyEmbed?

    func hash(into hasher: inout Hasher) {
        hasher.combine(cid)
    }

    static func == (lhs: BskyPostView, rhs: BskyPostView) -> Bool {
        lhs.cid == rhs.cid
    }
}

// MARK: - app.bsky.embed.images#view

/// 投稿に添付された画像などの埋め込みコンテンツ。
/// `$type` が `app.bsky.embed.images#view` の場合、`images` に画像一覧を持つ。
struct BskyEmbed: Codable {
    let type: String?
    let images: [BskyImage]?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case images
    }
}

// MARK: - app.bsky.embed.images#viewImage

/// 埋め込み画像 1 枚分の情報。
struct BskyImage: Codable {
    /// サムネイル画像の URL。
    let thumb: String?
    /// フルサイズ画像の URL。
    let fullsize: String?
    /// 代替テキスト。
    let alt: String?
    /// 画像の縦横比。
    let aspectRatio: BskyAspectRatio?
}

/// 画像の縦横比（ピクセル単位）。
struct BskyAspectRatio: Codable {
    let width: Int
    let height: Int
}

// MARK: - app.bsky.feed.post (record)

struct BskyPostRecord: Codable {
    let type: String?
    let text: String?
    let createdAt: String?
    let langs: [String]?
    let facets: [BskyFacet]?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case text
        case createdAt
        case langs
        case facets
    }
}

// MARK: - app.bsky.richtext.facet

/// テキストの一部（バイト範囲）に付与されるリッチテキスト情報。
/// リンク・メンション・ハッシュタグなどを `features` として持つ。
struct BskyFacet: Codable {
    let index: BskyFacetIndex
    let features: [BskyFacetFeature]
}

/// facet が対象とするテキストのバイト範囲。UTF-8 バイト単位のオフセット。
struct BskyFacetIndex: Codable {
    let byteStart: Int
    let byteEnd: Int
}

/// facet の機能。`$type` によって link / mention / tag を表し、
/// 種類ごとに使うフィールドが異なる（link は `uri`、mention は `did`、tag は `tag`）。
struct BskyFacetFeature: Codable {
    let type: String?
    /// app.bsky.richtext.facet#link の外部 URL。
    let uri: String?
    /// app.bsky.richtext.facet#mention の対象アカウント DID。
    let did: String?
    /// app.bsky.richtext.facet#tag のハッシュタグ文字列。
    let tag: String?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case uri
        case did
        case tag
    }
}

// MARK: - app.bsky.feed.defs#replyRef

struct BskyReplyRef: Codable {
    let root: BskyPostView?
    let parent: BskyPostView?
    let grandparentAuthor: BskyProfileViewBasic?

    enum CodingKeys: String, CodingKey {
        case root
        case parent
        case grandparentAuthor
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // root / parent は postView / notFoundPost / blockedPost の union。
        // notFoundPost・blockedPost には cid が無く BskyPostView としてデコードできないため、
        // その場合は nil として扱う。
        root = try? container.decodeIfPresent(BskyPostView.self, forKey: .root)
        parent = try? container.decodeIfPresent(BskyPostView.self, forKey: .parent)
        grandparentAuthor = try container.decodeIfPresent(BskyProfileViewBasic.self, forKey: .grandparentAuthor)
    }
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
