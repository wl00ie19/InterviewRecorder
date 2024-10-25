//
//  EditQuestionView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 9/25/24.
//

import SwiftUI
import SwiftData

struct EditQuestionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var question: Question
    
    @State private var initialContent: String = ""
    
    @FocusState private var focused: Bool
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 20) {
                    Text("수정할 질문 내용을 입력하세요.")
                        .font(.title3)
                    
                    QuestionEditor(content: $question.content)
                        .focused($focused)
                        .frame(height: geometry.size.height * 0.4)
                    
                    if question.content != initialContent {
                        Button {
                            question.content = initialContent
                        } label: {
                            Label("되돌리기", systemImage: "arrow.uturn.backward")
                                .foregroundStyle(.white)
                                .padding(10)
                                .background {
                                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .foregroundStyle(.blue)
                                }
                        }
                        .buttonStyle(CustomButtonStyle())
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
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("완료")
                        }
                    }
                }
                .navigationTitle("질문 내용 수정")
                .navigationBarTitleDisplayMode(.inline)
                .padding(10)
            }
        }
        .onAppear {
            initialContent = question.content
        }
    }
}
