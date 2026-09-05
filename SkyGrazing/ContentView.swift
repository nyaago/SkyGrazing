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

    var body: some View {
        if service.isLoggedIn {
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
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environment(BskyService())
}
