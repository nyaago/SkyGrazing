//
//  Router.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/06/28.
//

import Foundation
import SwiftUI

enum TimelineRoute: Hashable {
    /// ユーザープロフィール画面へ遷移
    case profile(BskyProfileViewBasic)
    /// 投稿詳細画面へ遷移
    case post(BskyPostView)
}

@Observable
final class TimelineRouter {
    var path = NavigationPath()
    func push(_ route: TimelineRoute) { path.append(route) }

    @ViewBuilder
    func destination(for route: TimelineRoute) -> some View {
        switch route {
        case .profile(let author):
            AuthorFeedView(actor: author.handle)
                .environment(self)
        case .post(let post):
            Text(post.record.text ?? "")
        }
    }
}
