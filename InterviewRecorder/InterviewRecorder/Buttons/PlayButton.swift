//
//  PlayButton.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/29/24.
//

import SwiftUI

struct PlayButton: View {
    @EnvironmentObject var recordManager: AudioRecordManager
    // 면접 질문
    @Binding var question: Question
    // 버튼 동작
    var action: () -> ()
    
    private let dateConverter = DateConverter.shared
    
    private var mainText: String {
        switch recordManager.status {
        case .stop:
            "답변 듣기"
        case .play:
            "재생 중 - \(dateConverter.toTimeString(elapsedTime: recordManager.elapsedTime)) / \(dateConverter.toTimeString(elapsedTime: question.answerLength ?? 0))"
        case .pause:
            "답변 이어 듣기"
        case .record:
            ""
        }
    }
    
    private var subText: String {
        switch recordManager.status {
        case .stop, .pause:
            if let date = question.lastAnsweredDate {
                "\(dateConverter.toDisplayString(date: date)) 녹음"
            } else {
                ""
            }
        case .play:
            "누르면 일시 정지"
        case .record:
            ""
        }
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundStyle(Color.playButton)
                            .frame(width: geometry.size.width)
                        
                        Rectangle()
                            .foregroundStyle(Color.nowPlaying)
                            .frame(width: geometry.size.width * (recordManager.elapsedTime / (question.answerLength ?? 1)))
                    }
                }
                
                VStack {
                    Text(mainText)
                        .font(.title2)
                    Text(subText)
                        .font(.subheadline)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .foregroundStyle(.white)
            }
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        }
            .buttonStyle(CustomButtonStyle())
    }
}
