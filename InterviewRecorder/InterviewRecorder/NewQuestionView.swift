//
//  NewQuestionView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/16/24.
//

import SwiftUI

struct NewQuestionView: View {
    @FocusState private var focused: Bool
    
    @State private var content: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                Text("새로운 질문을 입력하세요.")
                    .font(.title2)
                
                QuestionEditor(content: $content)
                    .focused($focused)
                    .frame(height: geometry.size.height * 0.4)
                
                ColorButton(title: "추가", buttonColor: .blue, textColor: Color(uiColor: .systemBackground)) {
                    
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
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    NewQuestionView()
}
