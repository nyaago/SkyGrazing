//
//  ThreadDisplayKind.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/21.
//

import Foundation

/// Thread 表示における投稿の種類を分類する wrapper
enum ThreadDisplayKind: BskyPostContainable {
    case parent(BskyThreadViewPost)
    case current(BskyThreadViewPost)
    case reply(BskyThreadViewPost)

    var post: BskyPostView {
        threadViewPost.post
    }

    var threadViewPost: BskyThreadViewPost {
        switch self {
        case .parent(let post),
             .current(let post),
             .reply(let post):
            return post
        }
    }
}
