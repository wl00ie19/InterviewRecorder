//
//  QuestionCell.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/27/24.
//

import SwiftUI

struct QuestionCell: View {
    // 버튼 텍스트
    var title: String
    // 편집모드 여부 - 편집모드에는 답변 녹음 이동 비활성화
    @Binding var isEditing: Bool
    // 버튼 동작
    var action: () -> ()
    // 삭제 동작
    var deleteAction: () -> ()
    
    struct CustomCell: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .overlay {
                    GeometryReader { geometry in
                        ZStack {
                            if configuration.isPressed {
                                Rectangle()
                                    .foregroundStyle(.foreground.opacity(0.1))
                            }
                        }
                        .frame(height: geometry.size.height)
                    }
                }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .trailing) {
                Button {
                    action()
                } label: {
                    HStack {
                        Text(title)
                            .font(.title2)
                        
                        Spacer()
                    }
                    .padding(15)
                }
                .foregroundStyle(.foreground)
                .buttonStyle(CustomCell())
                .disabled(isEditing)
                
                if isEditing {
                    DeleteButton {
                        deleteAction()
                    }
                    .padding(.horizontal, 15)
                }
            }
            
            Divider()
        }
    }
}
