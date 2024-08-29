//
//  AnswerRecordingView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/29/24.
//

import SwiftUI
import SwiftData

struct AnswerRecordingView: View {
    @Environment(\.modelContext) var modelContext
    
    var question: Question
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("질문: ")
                        .font(.headline)
                    
                    Text(question.content)
                        .font(.title)
                }
                
                Spacer()
            }
            .padding(.bottom, 30)
            
            if question.isAnswered {
                Text("답변한 질문입니다.")
            } else {
                Text("답변하지 않은 질문입니다.")
            }
            
            ColorButton(title: "녹음하기", buttonColor: .orange, textColor: Color(uiColor: .systemBackground)) {
                
            }
        }
        .padding(10)
    }
}
