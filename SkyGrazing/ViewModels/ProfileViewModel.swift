//
//  MyFeedViewModel.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/23.
//

import Foundation
import Observation

@Observable
class ProfileViewModel: FeedViewModelProtocol {
    var isLoading = false
    var isLoadingProfile = false
    var feedPosts: [BskyFeedViewPost] = []
    var profile: BskyProfile?

    private var cursor: String?
    private var hasMore = true

    private var limit: Int = 50
    private var moreLimit: Int = 30

    private var handle: String {
        UserSettings.handle
    }

    @MainActor
    func onAppear(service: BskyService) {
        guard !isLoading else { return }
        isLoading = true

        Task {
            defer { isLoading = false }
            async let feedResult = fetchFeed(service: service, limit: limit, cursor: nil)
            let feed = await feedResult
            if let feed {
                self.feedPosts = feed.feed ?? []
                self.cursor = feed.cursor
                self.hasMore = feed.cursor != nil
            }
            isLoading = true
        }
    }

    @MainActor
    func onAppearProfile(service: BskyService) {
        guard !isLoading else { return }
        isLoadingProfile = true

        Task {
            defer { isLoadingProfile = false }
            async let profileResult = fetchProfile(service: service)
            self.profile = await profileResult
            isLoadingProfile = true
        }
    }

    
    @MainActor
    func onDisappear() {
        // no polling for my feed
    }

    @MainActor
    func loadMore(service: BskyService) {
        guard !isLoading, hasMore, let cursor else { return }
        isLoading = true

        Task {
            defer { isLoading = false }
            let feed = await fetchFeed(service: service, limit: moreLimit, cursor: cursor)
            if let feed {
                self.feedPosts.append(contentsOf: feed.feed ?? [])
                self.cursor = feed.cursor
                self.hasMore = feed.cursor != nil
            }
        }
    }

    private func fetchProfile(service: BskyService) async -> BskyProfile? {
        let request = BskyProfileRequest(actor: handle)
        do {
            return try await service.fetch(request)
        } catch {
            print("profile error: \(error)")
            return nil
        }
    }

    private func fetchFeed(service: BskyService, limit: Int, cursor: String?) async -> BskyFeedPage? {
        let request = BskyAuthorFeedRequest(actor: handle, limit: limit, cursor: cursor)
        do {
            return try await service.fetch(request)
        } catch {
            print("feed error: \(error)")
            return nil
        }
    }
}
