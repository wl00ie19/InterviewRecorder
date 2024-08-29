//
//  ContentView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Question.questionDate) var questions: [Question]
    
    @State private var isShowingRecordAnswer: Bool = false
    
    @State private var isShowingNewQuestion: Bool = false
    
    @State private var isEditing: Bool = false
    
    @State private var isShowingDeleteAlert: Bool = false
    
    @State private var selectedQuestion: Question?
    
    var editButtonText: String {
        isEditing ? "완료" : "삭제"
    }
    
    var editIconName: String {
        isEditing ? "checkmark" : "trash"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    VStack(spacing: 10) {
                        VStack(spacing: 30) {
                            Text("답변하지 않은 질문")
                                .font(.headline)
                            
                            Text("EnvironmentObject는 무엇이고 어떤 경우 사용할까요?")
                                .font(.title)
                            
                            ColorButton(title: "답변하기", buttonColor: .blue, textColor: Color(uiColor: .systemBackground)) {
                                
                            }
                        }
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .strokeBorder(Color(uiColor: .systemGray3), lineWidth: 2)
                        }
                        
                        ColorButton(title: "질문 추가하기", buttonColor: Color(uiColor: .systemGray5)) {
                            isShowingNewQuestion.toggle()
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(10)
                    
                    ForEach(questions) { question in
                        QuestionCell(title: question.content, isEditing: $isEditing) {
                            
                        } deleteAction: {
                            selectedQuestion = question
                            isShowingDeleteAlert.toggle()
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            .navigationTitle("전체 답변 목록")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Label(editButtonText, systemImage: editIconName)
                    }
                    .disabled(questions.isEmpty)
                }
            }
            .navigationDestination(isPresented: $isShowingNewQuestion) {
                NewQuestionView(isShowingNewQuestion: $isShowingNewQuestion)
            }
            .alert("질문을 삭제할까요?", isPresented: $isShowingDeleteAlert) {
                Button("취소", role: .cancel) {
                    isShowingDeleteAlert = false
                    isEditing = false
                }
                
                Button("확인", role: .destructive) {
                    if let selectedQuestion {
                        modelContext.delete(selectedQuestion)
                    }
                    isShowingDeleteAlert = false
                    if questions.isEmpty {
                        isEditing = false
                    }
                }
            } message: {
                Text("녹음된 답변도 같이 삭제됩니다.")
            }
            
        }
    }
}

#Preview {
    ContentView()
}
