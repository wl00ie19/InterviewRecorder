//
//  ColorButton.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/20/24.
//

import SwiftUI

struct ColorButton: View {
    // 버튼 텍스트
    var title: String
    // 버튼 아이콘
    var icon: String?
    // 버튼 배경 색상
    var buttonColor: Color
    // 버튼 글자 색상
    var textColor: Color = .primary
    // 버튼 비활성화
    var isDisabled: Bool = false
    // 아이콘 크기
    var iconSize: CGFloat?
    // 버튼 동작
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                
                if let icon {
                    Label(title, systemImage: icon)
                        .foregroundStyle(textColor)
                        .padding(15)
                } else {
                    Text(title)
                        .foregroundStyle(textColor)
                        .padding(15)
                }
                
                Spacer()
            }
            .font(.title2)
            .background {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .foregroundStyle(buttonColor)
            }
        }
        .buttonStyle(CustomButtonStyle())
    }
}
