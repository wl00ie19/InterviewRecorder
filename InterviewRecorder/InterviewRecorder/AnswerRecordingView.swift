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
                PlayButton {
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
                        
                        if recordManager.status == .play {
                            VStack {
                                Text("재생 중 - \(dateConverter.toTimeString(elapsedTime: recordManager.elapsedTime)) / \(dateConverter.toTimeString(elapsedTime: question.answerLength ?? 0))")
                                    .font(.title2)
                                Text("누르면 일시 정지")
                                    .font(.subheadline)
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                            .foregroundStyle(.background)
                            
                        } else {
                            VStack {
                                Text("답변 듣기")
                                    .font(.title2)
                                if let date = question.lastAnsweredDate {
                                    Text("\(dateConverter.toDisplayString(date: date)) 녹음")
                                        .font(.subheadline)
                                }
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                            .foregroundStyle(.background)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .frame(height: 80)
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
