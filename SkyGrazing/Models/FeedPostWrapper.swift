//
//  PostDisplayKind.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/21.
//

import Foundation

/// Feed 一覧における投稿の種類を分類する wrapper
enum FeedPostWrapper: BskyPostContainable {
    case regular(BskyFeedViewPost)
    case reply(BskyFeedViewPost)
    case repost(BskyFeedViewPost)

    var post: BskyPostView {
        feedPost.post
    }

    var feedPost: BskyFeedViewPost {
        switch self {
        case .regular(let feedPost),
             .reply(let feedPost),
             .repost(let feedPost):
            return feedPost
        }
    }

    static func from(_ feedPost: BskyFeedViewPost) -> FeedPostWrapper {
        if feedPost.reason != nil {
            return .repost(feedPost)
        } else if feedPost.reply != nil {
            return .reply(feedPost)
        } else {
            return .regular(feedPost)
        }
    }
}
