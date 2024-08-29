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
    
    var body: some View {
        Button(action: action, label: label)
            .buttonStyle(CustomButtonStyle())
    }
}
