//
//  ProfileSectionBarView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/01.
//

import SwiftUI

enum ProfileSection: String, CaseIterable {
    case posts = "Posts"
    case replies = "Replies"
    case media = "Media"
    case likes = "Likes"
    case feeds = "Feeds"
}

struct ProfileSectionBarView: View {
    @Binding var selectedSection: ProfileSection

    var body: some View {
        HStack(spacing: 0) {
            ForEach(ProfileSection.allCases, id: \.self) { section in
                Button {
                    selectedSection = section
                } label: {
                    VStack(spacing: 4) {
                        Text(section.rawValue)
                            .font(.subheadline)
                            .fontWeight(selectedSection == section ? .bold : .regular)
                            .foregroundColor(selectedSection == section ? .primary : .secondary)
                        Rectangle()
                            .fill(selectedSection == section ? Color.accentColor : Color.clear)
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
    ProfileSectionBarView(selectedSection: .constant(.posts))
}
