//
//  CircleIconButton.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/11/03.
//

import SwiftUI

struct CircleIconButton: View {
    let action: () -> Void
    let imageName: String

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
}

#Preview {
    CircleIconButton(action: {
        print("tapped")
    }, imageName: "square.and.pencil")
}
