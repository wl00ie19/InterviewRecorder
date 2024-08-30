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
                        if let urlString = question.answerURLString {
                            recordManager.startPlay(fileURLString: urlString)
                            
                            print(urlString)
                        }
                    }
                    
                } label: {
                    Text("답변한 질문입니다.\(question.answerLength ?? 0.0) \(recordManager.errorMessage?.rawValue ?? "")")
                }
                .disabled(isRecording)

            } else {
                RecordVolumeGauge()
                    .frame(height: 80)
            }
            
            ColorButton(title: isRecording ? "정지" : "녹음하기" , buttonColor: isRecording ? .nowRecording : .recordButton, textColor: Color(uiColor: .systemBackground)) {
                if isRecording {
                    let (answerURLString, length) = recordManager.stopRecord()
                    
                    question.answerURLString = answerURLString
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
