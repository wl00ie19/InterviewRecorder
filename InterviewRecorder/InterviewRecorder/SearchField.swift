//
//  SearchField.swift
//  InterviewRecorder
//
//  Created by 이우석 on 9/26/24.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    
    @State var isUnansweredOnly: Bool = false
    
    @FocusState private var focused: Bool
    
    var checkIcon: String {
        isUnansweredOnly ? "checkmark.circle.fill" : "checkmark.circle"
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 5) {
                TextField("검색", text: $searchText)
                    .focused($focused)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(focused ? Color(uiColor: .systemGray3) : Color(uiColor: .systemGray5))
                
            }
            .animation(.easeIn(duration: 0.15), value: focused)
            
            Button {
                isUnansweredOnly.toggle()
            } label: {
                Label("답변하지 않은 질문만 보기", systemImage: checkIcon)
                    .foregroundStyle(isUnansweredOnly ? .white : .primary)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .foregroundStyle(isUnansweredOnly ? .blue : Color(uiColor: .systemGray5))
                    }
            }
            .buttonStyle(CustomButtonStyle())
        }
        .padding(10)
        .onAppear{
            #if canImport(UIKit)
            UITextField.appearance().clearButtonMode = .whileEditing
            #endif
        }
    }
}
