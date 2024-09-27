//
//  SearchField.swift
//  InterviewRecorder
//
//  Created by 이우석 on 9/26/24.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("검색", text: $searchText)
                .focused($focused)
            
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(focused ? Color(uiColor: .systemGray3) : Color(uiColor: .systemGray5))
        }
        .padding(10)
        .animation(.easeIn(duration: 0.15), value: focused)
        .onAppear{
            #if canImport(UIKit)
            UITextField.appearance().clearButtonMode = .whileEditing
            #endif
        }
    }
}
