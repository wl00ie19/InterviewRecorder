//
//  PlayButton.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/29/24.
//

import SwiftUI

struct PlayButton<T: View>: View {
    // 버튼 동작
    var action: () -> ()
    // 버튼 레이블
    var label: () -> T
    
    init(action: @escaping () -> (), @ViewBuilder label: @escaping () -> T) {
        self.action = action
        self.label = label
    }
    
    struct CustomButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
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
    
    var body: some View {
        Button(action: action, label: label)
            .buttonStyle(CustomButton())
    }
}
