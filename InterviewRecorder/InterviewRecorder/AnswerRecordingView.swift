//
//  AnswerRecordingView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/29/24.
//

import SwiftUI

struct AnswerRecordingView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("질문: ")
                    .font(.headline)
                
                Text("EnvironmentObject는 무엇이고 어떤 경우 사용할까요?")
                    .font(.title)
            }
            .padding(.bottom, 30)
            
            Text("답변하지 않은 질문입니다.")
            
            ColorButton(title: "녹음하기", buttonColor: .orange, textColor: Color(uiColor: .systemBackground)) {
                
            }
        }
        .padding(10)
    }
}

#Preview {
    AnswerRecordingView()
}
