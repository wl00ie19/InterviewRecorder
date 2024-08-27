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
    
    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                Button {
                    action()
                } label: {
                    HStack {
                        Text(title)
                            .font(.title2)
                        
                        Spacer()
                    }
                    .padding(10)
                }
                
                if isEditing {
                    Button {
                        deleteAction()
                    } label: {
                        Label("삭제", systemImage: "trash")
                            .labelStyle(.iconOnly)
                            .frame(height: 15)
                            .padding(5)
                            .background {
                                RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                                    .foregroundStyle(.red)
                            }
                    }
                }
            }
        }
    }
}
