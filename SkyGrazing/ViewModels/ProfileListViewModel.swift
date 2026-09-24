//
//  ProfileListViewModel.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/24.
//

import Foundation
import Observation

/// フォロワー / フォロー一覧など、`BskyProfile` の一覧をページングで表示する画面の共通 ViewModel。
/// リクエストの生成方法だけを差し替えて、フォロワー・フォローの両方で使い回す。
@Observable
class ProfileListViewModel<Request: BskyRequestable>
where Request.Response: BskyProfileListResponse {

    var isLoading = false
    var profiles: [BskyProfile] = []

    private var cursor: String?
    private var hasMore = true

    private var limit: Int
    private var moreLimit: Int

    private let makeRequest: (_ limit: Int?, _ cursor: String?) -> Request

    init(limit: Int = 30,
         moreLimit: Int = 20,
         makeRequest: @escaping (_ limit: Int?, _ cursor: String?) -> Request) {
        self.limit = limit
        self.moreLimit = moreLimit
        self.makeRequest = makeRequest
    }

    @MainActor
    func onAppear(service: BskyService) {
        guard !isLoading else { return }
        isLoading = true

        Task {
            defer { isLoading = false }
            let response = await fetchList(service: service, limit: limit, cursor: nil)
            if let response {
                self.profiles = response.profiles
                self.cursor = response.cursor
                self.hasMore = response.cursor != nil
            }
        }
    }

    @MainActor
    func loadMore(service: BskyService) {
        guard !isLoading, hasMore, let cursor else { return }
        isLoading = true

        Task {
            defer { isLoading = false }
            let response = await fetchList(service: service, limit: moreLimit, cursor: cursor)
            if let response {
                self.profiles.append(contentsOf: response.profiles)
                self.cursor = response.cursor
                self.hasMore = response.cursor != nil
            }
        }
    }

    private func fetchList(service: BskyService, limit: Int, cursor: String?) async -> Request.Response? {
        let request = makeRequest(limit, cursor)
        do {
            return try await service.fetch(request)
        } catch {
            print("profile list error: \(error)")
            return nil
        }
    }
}
