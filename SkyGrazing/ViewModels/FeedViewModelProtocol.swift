//
//  FeedViewModelProtocol.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/22.
//

import Foundation
import Observation

@MainActor
protocol FeedViewModelProtocol: Observable, AnyObject {
    var isLoading: Bool { get }
    var feedPosts: [BskyFeedViewPost] { get }
    func onAppear(service: BskyService)
}
