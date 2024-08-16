//
//  NewQuestionView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/16/24.
//

import SwiftUI

struct NewQuestionView: View {
    @State private var content: String = ""
    
    var body: some View {
        VStack {
            Text("새로운 질문을 입력하세요")
            
            TextEditor(text: $content)
            
            Button("추가") {
                
            }
        }
        .navigationTitle("질문 추가")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NewQuestionView()
}
