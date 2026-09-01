//
//  ProfileTabBarView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/01.
//

import SwiftUI

enum ProfileTab: String, CaseIterable {
    case posts = "Posts"
    case replies = "Replies"
    case media = "Media"
    case likes = "Likes"
    case feeds = "Feeds"
}

struct ProfileTabBarView: View {
    @Binding var selectedTab: ProfileTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(ProfileTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 4) {
                        Text(tab.rawValue)
                            .font(.subheadline)
                            .fontWeight(selectedTab == tab ? .bold : .regular)
                            .foregroundColor(selectedTab == tab ? .primary : .secondary)
                        Rectangle()
                            .fill(selectedTab == tab ? Color.accentColor : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1) // 線の太さ
                .foregroundColor(.secondary) // 線の色
        }
        .modifier(TabBarViewModifier())
    }
}

#Preview {
    ProfileTabBarView(selectedTab: .constant(.posts))
}
