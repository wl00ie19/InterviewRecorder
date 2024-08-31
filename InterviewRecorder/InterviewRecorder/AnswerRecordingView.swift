//
//  AnswerRecordingView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/29/24.
//

import SwiftUI
import SwiftData

struct AnswerRecordingView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var recordManager: AudioRecordManager
    @State var question: Question
    
    private var isRecording: Bool {
        recordManager.status == .record
    }
    
    private var timeText: String {
        recordManager.second >= 10 ? "\(recordManager.minute):\(recordManager.second)" : "\(recordManager.minute):0\(recordManager.second)"
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("질문: ")
                        .font(.headline)
                    
                    Text(question.content)
                        .font(.title)
                }
                
                Spacer()
            }
            .padding(.bottom, 30)
            
            if question.isAnswered {
                PlayButton {
                    if recordManager.status == .play {
                        recordManager.stopPlay()
                    } else {
                        if let fileName = question.answerFileName {
                            recordManager.startPlay(fileName: fileName)
                            
                            print(fileName)
                        }
                    }
                    
                } label: {
                    Text("답변한 질문입니다.\(timeText) \(recordManager.errorMessage?.rawValue ?? "")")
                }
                .disabled(isRecording)

            } else {
                RecordVolumeGauge()
                    .frame(height: 80)
            }
            
            ColorButton(title: isRecording ? "정지" : "녹음하기" , buttonColor: isRecording ? .nowRecording : .recordButton, textColor: Color(uiColor: .systemBackground)) {
                if isRecording {
                    let (answerURLString, length) = recordManager.stopRecord()
                    
                    question.answerFileName = answerURLString
                    question.answerLength = length
                    question.lastAnsweredDate = Date()
                    
                    modelContext.insert(question)
                } else {
                    recordManager.startRecord(questionID: question.id)
                }
            }
            .disabled(question.isAnswered)
        }
        .padding(10)
    }
}
