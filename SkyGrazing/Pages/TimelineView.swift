//
//  TimelineView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/22.
//

import SwiftUI

struct TimelineView: View {
    var body: some View {
        FeedView(viewModel: TimelineViewModel())
            .navigationTitle("Timeline")
    }
}

#Preview {
    NavigationStack {
        TimelineView()
    }
    .environment(BskyService())
}
