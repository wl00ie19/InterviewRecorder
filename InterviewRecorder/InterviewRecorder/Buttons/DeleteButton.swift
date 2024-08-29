//
//  DeleteButton.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/27/24.
//

import SwiftUI

struct DeleteButton: View {
    // 버튼 동작
    var deleteAction: () -> ()
    
    var body: some View {
        Button {
            deleteAction()
        } label: {
            Label("삭제", systemImage: "trash")
                .labelStyle(.iconOnly)
                .foregroundStyle(.background)
                .font(.system(size: 20))
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .background {
                    RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                        .foregroundStyle(.red)
                }
        }
        .buttonStyle(CustomButtonStyle())
    }
}
