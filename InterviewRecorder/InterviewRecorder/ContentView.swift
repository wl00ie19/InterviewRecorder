//
//  ContentView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingRecordAnswer: Bool = false
    @State private var isShowingNewQuestion: Bool = false
    
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
                }
                .padding(.vertical, 10)
            }
            .navigationTitle("전체 답변 목록")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .navigationDestination(isPresented: $isShowingNewQuestion) {
                NewQuestionView()
            }
        }
    }
}

#Preview {
    ContentView()
}
