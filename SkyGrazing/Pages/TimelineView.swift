//
//  TimelineView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/22.
//

import SwiftUI

struct TimelineView: View {
    @Environment(TimelineRouter.self) private var router
    
    var body: some View {
        FeedView(viewModel: FeedViewModel { limit, cursor in
                BskyTimelineRequest(limit: limit, cursor: cursor)
        })
        .navigationTitle("Timeline")
        .navigationDestination(for: TimelineRoute.self) { route in
            router.destination(for: route)
        }
    }
}

#Preview {
    NavigationStack {
        TimelineView()
    }
    .environment(BskyService())
    .environment(TimelineRouter())
}
