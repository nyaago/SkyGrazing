//
//  ContentView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/03/22.
//

import SwiftUI

/// TabView で切り替えるタブ。
enum AppTab: Hashable {
    case timeline
    case profile
}

struct ContentView: View {
    @Environment(BskyService.self) private var service
    @State var timelineRouter: TimelineRouter = .init()
    @State var profileRouter: TimelineRouter = .init()

    /// 現在選択中のタブ
    @State private var selectedTab: AppTab = .timeline

    /// メニューが開いているか
    @State private var isMenuOpen = false
    /// ドラッグ中の移動量（指の移動量）
    @State private var dragTranslation: CGFloat = 0

    /// フォロワー一覧のフローティング表示中か（メニューからの表示用）
    @State private var showFollowers = false

    /// 画面幅に対するメニュー幅の割合
    private let menuWidthRatio: CGFloat = 0.75
    /// メニュー幅の上限
    private let maxMenuWidth: CGFloat = 320

    var body: some View {
        Group {
            if service.isLoggedIn {
                GeometryReader { geometry in
                    // 画面幅からメニュー幅を決める（上限あり）
                    let menuWidth = min(geometry.size.width * menuWidthRatio, maxMenuWidth)
                    // 開/閉の基準位置 + ドラッグ量。範囲内にクランプして現在のオフセットを求める。
                    let base = isMenuOpen ? 0 : -menuWidth
                    let offset = min(0, max(-menuWidth, base + dragTranslation))
                    // メニューが開いている割合（0: 非表示, 1: 全表示）
                    let progress = Double((offset + menuWidth) / menuWidth)

                    ZStack(alignment: .leading) {
                        tabView

                        // 開いているときの背景。
                        if progress > 0 {
                            Color.black
                                .opacity(0.3 * progress)
                                .ignoresSafeArea()
                        }

                        menuView(width: menuWidth, offset: offset)

                        // メニューの Followers から開くフォロワー一覧（縦は中央60%、横は100%）。
                        if showFollowers {
                            followersOverlay(width: geometry.size.width,
                                             height: geometry.size.height)
                        }
                    }
                    .gesture(menuDragGesture(menuWidth: menuWidth))
                    .onTapGesture { closeMenu() }
                    .onAppear {
                        // ログイン直後などにメニューを閉じた状態から始める
                        isMenuOpen = false
                        dragTranslation = 0
                    }
                }
            } else {
                LoginView()
            }
        }
        .task {
            await restoreSessionIfNeeded()
        }
    }

    /// 未ログインなら、保存済みトークンでのセッション復元を一度だけ試す。
    private func restoreSessionIfNeeded() async {
        if !service.isLoggedIn {
            await service.restoreSession()
        }
    }

    /// タブ切り替え表示（Timeline / Profile）。
    private var tabView: some View {
        TabView(selection: $selectedTab) {
            Tab("Timeline", systemImage: "list.bullet", value: AppTab.timeline) {
                NavigationStack(path: $timelineRouter.path) {
                    TimelineView()
                        .toolbar { menuToolbar }
                }
                .environment(timelineRouter)
            }
            Tab("Profile", systemImage: "person.circle", value: AppTab.profile) {
                NavigationStack(path: $profileRouter.path) {
                    ProfileView(actor: UserSettings.handle)
                        .toolbar { menuToolbar }
                }
                .environment(profileRouter)
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .defaultAdaptableTabBarPlacement(.sidebar)
    }

    /// スライド式のサイドメニュー。
    private func menuView(width: CGFloat, offset: CGFloat) -> some View {
        MenuView(
            width: width,
            offset: offset,
            onSelectProfile: {
                // アカウント名/ハンドルのタップで Profile タブへ切り替えて閉じる
                selectedTab = .profile
                closeMenu()
            },
            onSelectFollowers: {
                // Followers のタップでメニューを閉じてフォロワー一覧を重ねて表示
                closeMenu()
                showFollowers = true
            }
        )
    }

    /// 現在表示中のタブに対応するルーター。フォロワー選択時の遷移先に使う。
    private var activeRouter: TimelineRouter {
        selectedTab == .timeline ? timelineRouter : profileRouter
    }

    /// メインコンテンツの上に重ねるフォロワー一覧（メニュー起点）。
    private func followersOverlay(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { showFollowers = false }

            FollowersView(actor: UserSettings.handle) { showFollowers = false }
                .frame(width: width, height: height * 0.6)
        }
        .frame(width: width, height: height)
        .environment(activeRouter)
    }

    /// ナビバー左上のハンバーガーボタン。
    @ToolbarContentBuilder
    private var menuToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                toggleMenu()
            } label: {
                Image(systemName: "line.3.horizontal")
            }
        }
    }

    /// メニューの開閉を切り替える。
    private func toggleMenu() {
        withAnimation(.easeOut(duration: 0.25)) {
            isMenuOpen.toggle()
            dragTranslation = 0
        }
    }

    /// メニューのオフセットを変更するドラッグ操作。
    private func menuDragGesture(menuWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragTranslation = value.translation.width
            }
            .onEnded { value in
                // ドラッグ後の位置が半分を超えていれば開く、そうでなければ閉じる。
                let predicted = (isMenuOpen ? 0 : -menuWidth) + value.translation.width
                withAnimation(.easeOut(duration: 0.25)) {
                    isMenuOpen = predicted > -menuWidth / 2
                    dragTranslation = 0
                }
            }
    }

    /// メニューを閉じる。
    private func closeMenu() {
        withAnimation(.easeOut(duration: 0.25)) {
            isMenuOpen = false
            dragTranslation = 0
        }
    }
}

#Preview {
    ContentView()
        .environment(BskyService())
}
