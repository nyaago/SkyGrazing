//
//  TimelineView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/22.
//

import SwiftUI

struct TimelineView: View {
    @State var router: TimelineRouter = .init()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            FeedView(viewModel: TimelineViewModel())
                .navigationTitle("Timeline")

        }
        .environment(router)
    }
}

#Preview {
    NavigationStack {
        TimelineView()
    }
    .environment(BskyService())
}
