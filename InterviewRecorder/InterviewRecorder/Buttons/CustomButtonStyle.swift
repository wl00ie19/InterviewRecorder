//
//  CustomButtonStyle.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/29/24.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .overlay {
                GeometryReader { geometry in
                    ZStack {
                        if configuration.isPressed {
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .foregroundStyle(.foreground.opacity(0.1))
                        }
                    }
                    .frame(height: geometry.size.height)
                }
            }
    }
}
