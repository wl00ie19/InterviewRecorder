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
                LazyVStack(spacing: 20) {
                    VStack {
                        Text("답변하지 않은 질문")
                        
                        Text("질문 내용")
                            .font(.title2)
                        
                        Button("답변하기") {
                            
                        }
                    }
                    
                    Button("질문 추가하기") {
                        isShowingNewQuestion.toggle()
                    }
                }
            }
            .navigationTitle("전체 답변 목록")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Label("앱 정보", systemImage: "info.circle")
                    }
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
