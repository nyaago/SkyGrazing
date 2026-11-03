//
//  ResponsiveModalModifier.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/11/03.
//

import SwiftUI

/// 端末のサイズクラスに応じて自動で切り替えるカスタムモディファイア
struct ResponsiveModalModifier<ModalContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var modalContent: () -> ModalContent
    
    // 画面の横幅クラスを取得 (.compact = iPhone縦 など, .regular = iPadなど)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    func body(content: Content) -> some View {
        if horizontalSizeClass == .compact {
            // iPhoneなどの狭い画面：fullScreenCoverで表示
            content.fullScreenCover(isPresented: $isPresented, content: modalContent)
        } else {
            // iPadなどの広い画面：sheetで表示
            content.sheet(isPresented: $isPresented, content: modalContent)
        }
    }
}
