//
//  BskyProfile.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/03/29.
//

// https://docs.bsky.app/docs/api/app-bsky-actor-get-profile

import Foundation

struct BskyProfile: Codable {
    // required
    let did: String
    let handle: String
    
    // required
    let displayName: String?
    let description: String?
    let avatar: String?
    let banner: String?
    let followersCount: Int?
    let followsCount: Int?
    let postCount: Int?
    let indexedAt: Date?
    let createdAt: Date?
    
    let error: String?
    let message: String?
    var isError: Bool {
        return error != nil
    }
    
    var indexedAtIso8601: String {
        guard let indexedAt else { return "" }
        return indexedAt.formatted(Date.ISO8601FormatStyle())
    }

    var createdAtIso8601: String {
        guard let createdAt else { return "" }
        return createdAt.formatted(Date.ISO8601FormatStyle())
    }

    let associated: BskyProfileAssociated?
    let viewer: BskyViewerState?
    let labels: [BskyLabel]?
    let verification: BskyVerificationState?
    let status: BskyStatusView?
    let pinnedPost: BskyStrongRef?
    
    /*
     * other attributes
    let debug: [String: Any]?
     */
}


// MARK: - app.bsky.actor.defs#profileAssociated
 
struct BskyProfileAssociated: Codable {
    let lists: Int?
    let feedgens: Int?
    let starterPacks: Int?
    let labeler: Bool?
    let chat: BskyProfileAssociatedChat?
    let activitySubscription: BskyProfileAssociatedActivitySubscription?
}
 
struct BskyProfileAssociatedChat: Codable {
    let allowIncoming: String?
}
 
struct BskyProfileAssociatedActivitySubscription: Codable {
    let allowSubscriptions: String?
}
 
// MARK: - app.bsky.actor.defs#viewerState
 
struct BskyViewerState: Codable {
    let muted: Bool?
    let mutedByList: BskyListViewBasic?
    let blockedBy: Bool?
    let blocking: String?
    let blockingByList: BskyListViewBasic?
    let following: String?
    let followedBy: String?
    let knownFollowers: BskyKnownFollowers?
}
 
// MARK: - app.bsky.actor.defs#knownFollowers
 
struct BskyKnownFollowers: Codable {
    let count: Int
    let followers: [BskyProfileViewBasic]
}
 
// MARK: - app.bsky.actor.defs#profileViewBasic
 
struct BskyProfileViewBasic: Codable {
    let did: String
    let handle: String
    let displayName: String?
    let avatar: String?
    let associated: BskyProfileAssociated?
    let viewer: BskyViewerState?
    let labels: [BskyLabel]?
    let createdAt: String?
}
 
// MARK: - app.bsky.graph.defs#listViewBasic
 
struct BskyListViewBasic: Codable {
    let uri: String
    let cid: String
    let name: String
    let purpose: String
    let avatar: String?
    let listItemCount: Int?
    let labels: [BskyLabel]?
    let viewer: BskyListViewerState?
    let indexedAt: String?
}
 
struct BskyListViewerState: Codable {
    let muted: Bool?
    let blocked: String?
}
 
// MARK: - com.atproto.label.defs#label
 
struct BskyLabel: Codable {
    let ver: Int?
    let src: String
    let uri: String
    let cid: String?
    let val: String
    let neg: Bool?
    let cts: String
    let exp: String?
    let sig: String?      // base64-encoded bytes
}
 
// MARK: - app.bsky.actor.defs#verificationState
 
struct BskyVerificationState: Codable {
    let verifications: [BskyVerificationView]?
}
 
struct BskyVerificationView: Codable {
    let issuer: String?
    let uri: String?
    let isValid: Bool?
}
 
// MARK: - app.bsky.actor.defs#statusView
 
struct BskyStatusView: Codable {
    let status: String?
    let embed: BskyStatusViewEmbed?
}
 
struct BskyStatusViewEmbed: Codable {
    // open union — 未知の型に備えて柔軟にデコード
    let type: String?
 
    enum CodingKeys: String, CodingKey {
        case type = "$type"
    }
}
 
// MARK: - com.atproto.repo.strongRef
 
struct BskyStrongRef: Codable {
    let uri: String
    let cid: String
}
