//
//  ContentView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/03/22.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(BskyService.self) private var service

    var body: some View {
        if service.isLoggedIn {
            TabView {
                Tab("Timeline", systemImage: "list.bullet") {
                    NavigationStack {
                        TimelineView()
                    }
                }
                Tab("Profile", systemImage: "person.circle") {
                    NavigationStack {
                        ProfileView()
                    }
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
