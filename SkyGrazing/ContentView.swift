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

                        // 開いているときの背景。
                        if progress > 0 {
                            Color.black
                                .opacity(0.3 * progress)
                                .ignoresSafeArea()
                        }

                        MenuView(width: menuWidth, offset: offset) {
                            // アカウント名/ハンドルのタップで Profile タブへ切り替えて閉じる
                            selectedTab = .profile
                            closeMenu()
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
            // 未ログインなら、保存済みトークンでのセッション復元を一度だけ試す
            if !service.isLoggedIn {
                await service.restoreSession()
            }
        }
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
