//
//  ContentView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/03/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(BskyService.self) private var service
    @State var timelineRouter: TimelineRouter = .init()
    @State var profileRouter: TimelineRouter = .init()

    /// メニューが開いているか
    @State private var isMenuOpen = false
    /// ドラッグ中の移動量（指の移動量）
    @State private var dragTranslation: CGFloat = 0

    /// 画面幅に対するメニュー幅の割合
    private let menuWidthRatio: CGFloat = 0.75
    /// メニュー幅の上限
    private let maxMenuWidth: CGFloat = 320

    var body: some View {
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
                    TabView {
                        Tab("Timeline", systemImage: "list.bullet") {
                            NavigationStack(path: $timelineRouter.path) {
                                TimelineView()
                            }
                            .environment(timelineRouter)
                        }
                        Tab("Profile", systemImage: "person.circle") {
                            NavigationStack(path: $profileRouter.path) {
                                ProfileView(actor: UserSettings.handle)
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

                    MenuView(width: menuWidth, offset: offset)
                }
                .gesture(menuDragGesture(menuWidth: menuWidth))
                .onTapGesture { closeMenu() }
            }
        } else {
            LoginView()
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
