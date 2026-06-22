//
//  TimelineViewModel.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/20.
//

import Foundation
import Observation

@Observable
class TimelineViewModel: FeedViewModelProtocol {
    var isLoading = false
    var feedPosts: [BskyFeedViewPost] = []

    @MainActor
    func onAppear(service: BskyService) {
        guard !isLoading else { return }
        isLoading = true

        Task {
            defer { isLoading = false }
            let request = BskyTimelineRequest(limit: 20)
            do {
                let timeline = try await service.fetch(request)
                self.feedPosts = timeline.feed ?? []
            } catch {
                print("error: \(error)")
            }
        }
    }
}
