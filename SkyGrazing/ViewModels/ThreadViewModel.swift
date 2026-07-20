//
//  ThreadViewModel.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/07/16.
//

import Foundation
import Observation

@Observable
class ThreadViewModel {
    var isLoading = false
    var thread: BskyThreadViewPost?

    let uri: String

    init(uri: String) {
        self.uri = uri
    }

    @MainActor
    func onAppear(service: BskyService) {
        guard !isLoading else { return }
        isLoading = true

        Task {
            defer { isLoading = false }
            let request = BskyPostThreadRequest(uri: uri)
            do {
                let response = try await service.fetch(request)
                self.thread = response.thread
            } catch {
                print("error: \(error)")
            }
        }
    }

    
    @MainActor
    func onDisappear() {
        
    }
    /// スレッドのリプライをフラットなリストに変換する
    func flattenReplies() -> [BskyThreadViewPost] {
        guard let thread else { return [] }
        var result: [BskyThreadViewPost] = []
        collectReplies(from: thread, into: &result)
        return result
    }

    /// 親投稿を遡ってフラットなリストに変換する（古い順）
    func flattenParents() -> [BskyThreadViewPost] {
        guard let thread else { return [] }
        var result: [BskyThreadViewPost] = []
        var current = thread.parent
        while let parent = current {
            result.append(parent)
            current = parent.parent
        }
        return result.reversed()
    }

    private func collectReplies(from node: BskyThreadViewPost, into result: inout [BskyThreadViewPost]) {
        guard let replies = node.replies else { return }
        for reply in replies {
            result.append(reply)
            collectReplies(from: reply, into: &result)
        }
    }
}
