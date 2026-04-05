//
//  BskyProfile.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/03/29.
//

import Foundation

struct BskyProfile: Codable {
    let did: String
    let handle: String
    let displayName: String?
    let description: String?
    let avatar: String?
    let banner: String?
    let followersCount: Int?
    let followsCount: Int?
    let postCount: Int?
    let indexedAt: Date?
    let createdAt: Date?
    
    var indexedAtIso8601: String {
        guard let indexedAt else { return "" }
        return indexedAt.formatted(Date.ISO8601FormatStyle())
    }

    var createdAtIso8601: String {
        guard let createdAt else { return "" }
        return createdAt.formatted(Date.ISO8601FormatStyle())
    }

    /*
    let associated: ProfileAssociated?
    let joinedViaStarterPack: AppBskyGraphDefs.StarterPackViewBasic?
    let viewer: ViewerState?
    let labels: [ComAtprotoLabelDefs.Label]?
    let pinnedPost: ComAtprotoRepoStrongRef.Main?
    let verification: VerificationState?
    let status: StatusView?
    let debug: [String: Any]?
     */
}
