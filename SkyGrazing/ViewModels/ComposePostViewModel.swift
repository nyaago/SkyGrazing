//
//  ComposePostViewModel.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/11/03.
//

import Foundation
import Observation

/// 投稿作成画面の状態と送信処理を管理する ViewModel。
@Observable
class ComposePostViewModel {
    /// 入力中の投稿テキスト。
    var text: String = ""
    /// 送信処理中かどうか。
    var isPosting = false
    /// 送信失敗時のエラーメッセージ。
    var errorMessage: String?
    /// 自分のプロフィール画像 URL。
    var avatar: String?

    /// 入力可能な最大文字数。
    let maxCharacterCount = 300

    /// 現在の入力文字数。
    var characterCount: Int {
        text.count
    }

    /// 送信可能かどうか。空文字・上限超過・送信中は不可。
    var canSubmit: Bool {
        !isPosting
            && !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && characterCount <= maxCharacterCount
    }

    /// ログイン中ユーザーのプロフィール画像を取得する。
    @MainActor
    func loadProfile(service: BskyService) {
        let handle = UserSettings.handle
        guard !handle.isEmpty else { return }
        Task {
            do {
                let profile = try await service.fetch(BskyProfileRequest(actor: handle))
                self.avatar = profile.avatar
            } catch {
                print("compose profile error: \(error)")
            }
        }
    }

    /// 投稿を送信する。成功したら true を返す。
    @MainActor
    func submit(service: BskyService) async -> Bool {
        let handle = UserSettings.handle
        guard !handle.isEmpty else { return false }

        isPosting = true
        errorMessage = nil
        defer { isPosting = false }

        let request = BskyCreateRecordRequest(repo: handle, text: text)
        do {
            _ = try await service.post(request)
            return true
        } catch {
            print("create post error: \(error)")
            errorMessage = "投稿に失敗しました"
            return false
        }
    }
}
