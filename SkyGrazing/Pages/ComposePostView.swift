//
//  ComposePostView.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/11/03.
//

import SwiftUI

/// テキスト投稿を作成する画面。
/// 1行のヘッダー・テキスト入力のボディ・1行のフッターで構成される。
struct ComposePostView: View {
    @Environment(BskyService.self) private var service
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ComposePostViewModel()
    @FocusState private var isTextFocused: Bool

    private let rowHeight: CGFloat = 44
    private let avatarSize: CGFloat = 44

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            composeBody
            Divider()
            footer
        }
        .onAppear {
            viewModel.loadProfile(service: service)
            isTextFocused = true
        }
    }

    /// 左に閉じるボタン、右に送信ボタンを持つヘッダー。
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
            }

            Spacer()

            if viewModel.isPosting {
                ProgressView()
                    .padding(.trailing, 4)
            }

            Button {
                Task {
                    let success = await viewModel.submit(service: service)
                    if success {
                        dismiss()
                    }
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.title3)
            }
            .disabled(!viewModel.canSubmit)
        }
        .padding(.horizontal)
        .frame(height: rowHeight)
    }

    /// 左上にプロフィール画像、その右側にテキスト入力エリアを持つボディ。
    private var composeBody: some View {
        HStack(alignment: .top, spacing: 12) {
            ProfileAvatarView(avatar: viewModel.avatar, size: avatarSize)

            ZStack(alignment: .topLeading) {
                if viewModel.text.isEmpty {
                    Text("いまどうしてる？")
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                TextEditor(text: $viewModel.text)
                    .focused($isTextFocused)
                    .scrollContentBackground(.hidden)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    /// 右側に入力文字数 / 入力可能文字数を表示するフッター。
    private var footer: some View {
        HStack {
            Spacer()
            Text("\(viewModel.characterCount)/\(viewModel.maxCharacterCount)")
                .font(.caption)
                .foregroundStyle(
                    viewModel.characterCount > viewModel.maxCharacterCount ? .red : .secondary
                )
        }
        .padding(.horizontal)
        .frame(height: rowHeight)
    }
}

#Preview {
    ComposePostView()
        .environment(BskyService())
}
