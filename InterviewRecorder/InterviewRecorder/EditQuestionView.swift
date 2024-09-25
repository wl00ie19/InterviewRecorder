//
//  EditQuestionView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 9/25/24.
//

import SwiftUI
import SwiftData

struct EditQuestionView: View {
    @FocusState private var focused: Bool
    
    @Binding var isShowingNewQuestion: Bool
    
    @State private var newContent: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                Text("수정할 질문 내용을 입력하세요.")
                    .font(.title3)
                
                QuestionEditor(content: $newContent)
                    .focused($focused)
                    .frame(height: geometry.size.height * 0.4)
                
                ColorButton(title: "수정", buttonColor: .blue, textColor: Color(uiColor: .systemBackground), isDisabled: newContent.isEmpty) {
                    
                }
                
                Spacer()
            }
            .background {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(.background)
                    .onTapGesture {
                        focused = false
                    }
            }
            .navigationTitle("질문 내용 수정")
            .navigationBarTitleDisplayMode(.inline)
            .padding(10)
        }
    }
}
