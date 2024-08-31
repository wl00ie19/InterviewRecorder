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
    
    private let dateConverter = DateConverter.shared
    
    private var isRecording: Bool {
        recordManager.status == .record
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
                PlayButton(question: $question) {
                    switch recordManager.status {
                    case .stop:
                        if let fileName = question.answerFileName {
                            recordManager.startPlay(fileName: fileName)
                        }
                    case .play:
                        recordManager.pausePlay()
                    case .pause:
                        recordManager.resumePlay()
                    case .record:
                        break
                    }
                }
                .frame(height: 80)
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
