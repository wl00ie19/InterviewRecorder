//
//  QuestionEditor.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/26/24.
//

import SwiftUI

struct QuestionEditor: View {
    @FocusState private var focused: Bool
    
    @Binding var content: String
    
    var body: some View {
        TextEditor(text: $content)
            .focused($focused)
            .font(.title3)
            .padding(10)
            .background {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .strokeBorder(focused ? Color(uiColor: .systemGray3) : Color(uiColor: .systemGray5), lineWidth: 2)
            }
            .padding(.horizontal, 10)
            .animation(.easeIn(duration: 0.15), value: focused)
        
    }
}
