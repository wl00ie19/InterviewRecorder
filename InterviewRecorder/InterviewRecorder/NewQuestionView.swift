//
//  NewQuestionView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/16/24.
//

import SwiftUI
import SwiftData

struct NewQuestionView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Question.questionDate) var questions: [Question]
    
    @FocusState private var focused: Bool
    
    @Binding var isShowingNewQuestion: Bool
    
    @State private var content: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                Text("새로운 질문을 입력하세요.")
                    .font(.title3)
                
                QuestionEditor(content: $content)
                    .focused($focused)
                    .frame(height: geometry.size.height * 0.4)
                
                ColorButton(title: "추가", buttonColor: .blue, textColor: Color(uiColor: .systemBackground), isDisabled: content.isEmpty) {
                    if !content.isEmpty {
                        isShowingNewQuestion = false
                        modelContext.insert(Question(id: UUID().uuidString, content: content, questionDate: Date()))
                    }
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
            .navigationTitle("질문 추가")
            .navigationBarTitleDisplayMode(.inline)
            .padding(10)
        }
    }
}

#Preview {
    NewQuestionView(isShowingNewQuestion: .constant(true))
}
