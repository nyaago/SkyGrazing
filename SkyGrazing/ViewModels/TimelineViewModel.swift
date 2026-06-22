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
    private var cursor: String?
    private var hasMore = true

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
                self.cursor = timeline.cursor
                self.hasMore = timeline.cursor != nil
            } catch {
                print("error: \(error)")
            }
        }
    }

    @MainActor
    func loadMore(service: BskyService) {
        guard !isLoading, hasMore, let cursor else { return }
        isLoading = true

        Task {
            defer { isLoading = false }
            let request = BskyTimelineRequest(limit: 20, cursor: cursor)
            do {
                let timeline = try await service.fetch(request)
                self.feedPosts.append(contentsOf: timeline.feed ?? [])
                self.cursor = timeline.cursor
                self.hasMore = timeline.cursor != nil
            } catch {
                print("error: \(error)")
            }
        }
    }
}
