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
    private var pollingTask: Task<Void, Never>?

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

        startPolling(service: service)
    }

    @MainActor
    func onDisappear() {
        pollingTask?.cancel()
        pollingTask = nil
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

    @MainActor
    private func startPolling(service: BskyService) {
        pollingTask?.cancel()
        pollingTask = Task {
            while !Task.isCancelled {
                do {
                    try await Task.sleep(for: .seconds(60))
                } catch {
                    break
                }
                guard !Task.isCancelled, !isLoading else { continue }
                let request = BskyTimelineRequest(limit: 20)
                do {
                    let timeline = try await service.fetch(request)
                    let newPosts = (timeline.feed ?? []).filter { newPost in
                        !self.feedPosts.contains(where: { $0.post.cid == newPost.post.cid })
                    }
                    if !newPosts.isEmpty {
                        self.feedPosts.insert(contentsOf: newPosts, at: 0)
                    }
                } catch {
                    print("polling error: \(error)")
                }
            }
        }
    }
}
