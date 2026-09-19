//
//  MenuView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/17.
//

import SwiftUI

/// 左からスライドして出現するメニュー。
/// 幅(width)と表示位置(offset)は呼び出し側から渡され、DragGesture 等の操作も呼び出し側で行う。
/// 非表示時は offset を -width にしておく。
struct MenuView: View {
    @Environment(BskyService.self) private var service
    /// メニューの幅
    let width: CGFloat

    /// メニュー本体の現在のオフセット。非表示時は -width。
    let offset: CGFloat

    /// アカウント名・ハンドルのタップで ProfileView のタブへ切り替える。
    var onSelectProfile: () -> Void = {}

    /// メニューに表示する自分のプロフィール。
    @State private var profile: BskyProfile?

    var body: some View {
        menuContent
            .frame(width: width)
            .frame(maxHeight: .infinity)
            .background(.regularMaterial)
            .offset(x: offset)
            .task { await loadProfile() }
    }

    /// メニュー内のコンテンツ。上部にアカウント情報、一番下に Sign Out ボタンを配置する。
    private var menuContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            accountHeader
                .padding(.horizontal)
                .padding(.top, 60)
            Divider()

            Spacer()

            Divider()

            Button(role: .destructive) {
                logout()
            } label: {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    .font(.headline)
                    .padding(.vertical, 12)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// 上部のアカウント情報（名前・ハンドル・フォロワー/フォロー数）。
    private var accountHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            // アカウント名 → ProfileView のタブへ
            Button(action: onSelectProfile) {
                Text(displayName)
                    .modifier(HeaderTitleModifier())
            }
            .modifier(HeaderElementModifier())

            // ハンドル → ProfileView のタブへ
            Button(action: onSelectProfile) {
                Text("@\(handle)")
                    .modifier(CaptionModifier())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .modifier(HeaderElementModifier())

            // フォロワー数・フォロー数（今はテキストのみ）
            HStack(spacing: 12) {
                Text("\(followersCount) Followers")
                    .modifier(CellActionButtonModifier())
                Text("\(followsCount) Following")
                    .modifier(CellActionButtonModifier())
            }
            .modifier(HeaderElementModifier())
        }
    }

    private var displayName: String {
        profile?.displayName ?? UserSettings.handle
    }

    private var handle: String {
        profile?.handle ?? UserSettings.handle
    }

    private var followersCount: Int {
        profile?.followersCount ?? 0
    }

    private var followsCount: Int {
        profile?.followsCount ?? 0
    }

    /// 自分のプロフィールを取得する。
    private func loadProfile() async {
        let actor = UserSettings.handle
        guard !actor.isEmpty else { return }
        do {
            profile = try await service.fetch(BskyProfileRequest(actor: actor))
        } catch {
            print("menu profile error: \(error)")
        }
    }

    private func logout() {
        service.logout()
    }
}

#Preview {
    MenuView(width: 270, offset: 0)
}
