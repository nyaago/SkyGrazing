//
//  FollowsView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/27.
//

import SwiftUI

/// アカウントのフォロー一覧を表示するフローティング View。
/// メインコンテンツの上に ZStack で重ねて使う想定で、サイズ・配置は呼び出し側が決める。
/// 要素の選択で対象アカウントの ProfileView へ遷移する（Navigation Path を下る）。
struct FollowsView: View {
    @Environment(BskyService.self) private var service
    @Environment(TimelineRouter.self) private var router
    @State private var viewModel: ProfileListViewModel<BskyFollowsRequest>

    /// 閉じる操作。呼び出し側が表示状態を制御する。
    let onDismiss: () -> Void

    init(actor: String, onDismiss: @escaping () -> Void = {}) {
        self.onDismiss = onDismiss
        _viewModel = State(initialValue: ProfileListViewModel(limit: 30, moreLimit: 20) { limit, cursor in
            BskyFollowsRequest(actor: actor, limit: limit, cursor: cursor)
        })
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            ThickDivider()
            content
        }
        .modifier(OverlayViewModifier())
        .onAppear { viewModel.onAppear(service: service) }
    }

    /// 見出しと閉じるボタン。
    private var header: some View {
        ZStack {
            Text("Following")
                .modifier(HeaderTitleModifier())
            HStack {
                Spacer()
                CloseButtonView(action: onDismiss)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
    }

    /// フォローの一覧。最下部付近で次ページを読み込む。
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.profiles.isEmpty {
            Spacer()
            ProgressView()
            Spacer()
        } else {
            List(viewModel.profiles, id: \.did) { profile in
                row(for: profile)
                    .onAppear {
                        if isNearBottom(profile) {
                            viewModel.loadMore(service: service)
                        }
                    }
            }
            .listStyle(.plain)
        }
    }

    /// アカウント名・ハンドルを改行して並べた行。タップで ProfileView へ遷移する。
    private func row(for profile: BskyProfile) -> some View {
        Button {
            router.push(.profile(profile.asProfileViewBasic))
            onDismiss()
        } label: {
            HStack(spacing: 0) {
                ProfileAvatarView(avatar: profile.avatar)
                    .padding(.horizontal, 8)
                VStack(alignment: .leading, spacing: 2) {
                    Text(profile.displayName ?? profile.handle)
                        .modifier(HeadlineModifier())
                    Text("@" + profile.handle)
                        .modifier(CaptionModifier())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                DisclosureArrowView()
            }
        }
        .buttonStyle(.plain)
    }

    /// 一番下から3つ目以内に入っているか。
    private func isNearBottom(_ profile: BskyProfile) -> Bool {
        guard let index = viewModel.profiles.firstIndex(where: { $0.did == profile.did }) else {
            return false
        }
        return index >= viewModel.profiles.count - 3
    }
}
