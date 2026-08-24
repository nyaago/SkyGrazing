//
//  FeedViewModel.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/28.
//

import Foundation
import Observation

@Observable
class FeedViewModel<Request: BskyRequestable>: FeedViewModelProtocol
where Request.Response == BskyFeedPage {
    
    var isLoading = false
    var feedPosts: [BskyFeedViewPost] = []
    private var cursor: String?
    private var hasMore = true
    private var pollingTask: Task<Void, Never>?
    
    private var moreNewPostsExist: Bool = false
    
    private var secondToPolling: Int = 120
    private var limit: Int = 50
    private var moreLimit: Int = 30
    private var autoPolling: Bool = true
    
    private let makeRequest: (_ limit: Int?, _ cursor: String?) -> Request
    
    init(makeRequest: @escaping (_ limit: Int?, _ cursor: String?) -> Request) {
        self.makeRequest = makeRequest
    }
    
    @MainActor
    func onAppear(service: BskyService) {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            defer { isLoading = false }
            let timeline = await fetchFeed(service: service, limit: limit, cursor: nil)
            if let timeline {
                self.feedPosts = timeline.feed ?? []
                self.cursor = timeline.cursor
                self.hasMore = timeline.cursor != nil
            }
        }
        if autoPolling {
            startPolling(service: service)
        }
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
            let timeline = await fetchFeed(service: service, limit: limit, cursor: cursor)
            if let timeline {
                self.feedPosts.append(contentsOf: timeline.feed ?? [])
                self.cursor = timeline.cursor
                self.hasMore = timeline.cursor != nil
            }
        }
    }
    
    // TODO 自動polling はやめて scroll で取りに行く、新しいpost の有無は監視して通知させるか?
    @MainActor
    private func startPolling(service: BskyService) {
        pollingTask?.cancel()
        pollingTask = Task {
            while !Task.isCancelled {
                do {
                    try await Task.sleep(for: .seconds(secondToPolling))
                } catch {
                    break
                }
                guard !Task.isCancelled, !isLoading else { continue }
                let request = makeRequest(limit, nil)
                do {
                    moreNewPostsExist = false
                    let timeline = try await service.fetch(request)
                    let newPosts = (timeline.feed ?? []).filter { newPost in
                        !self.feedPosts.contains(where: { $0.post.cid == newPost.post.cid })
                    }
                    if !newPosts.isEmpty {
                        self.feedPosts.insert(contentsOf: newPosts, at: 0)
                    }
                    moreNewPostsExist = (timeline.feed ?? []).filter { newPost in
                        !self.feedPosts.contains(where: { $0.post.cid == newPost.post.cid })
                    }.isEmpty == false
                } catch {
                    print("polling error: \(error)")
                }
            }
        }
    }
    private func fetchFeed(service: BskyService, limit: Int, cursor: String?) async -> BskyFeedPage? {
        let request = makeRequest(limit, cursor)
        do {
            return try await service.fetch(request)
        } catch {
            print("feed error: \(error)")
            return nil
        }
    }

    
}


