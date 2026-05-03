//
//  SkyGrazingApp.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/03/22.
//

import SwiftUI
import SwiftData

@main
struct SkyGrazingApp: App {
    @State private var bskyService = BskyService()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bskyService)
        }
        .modelContainer(sharedModelContainer)
    }
}
