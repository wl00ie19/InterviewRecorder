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
    
    @State private var isShowingRerecordAlert: Bool = false
    
    @State private var isShowingEditSheet: Bool = false
    
    @Binding var tempAnswerFileName: String?
    
    @Binding var tempAnswerLength: Double?
    
    private let dateConverter = DateConverter.shared
    
    private var isRecording: Bool {
        recordManager.status == .record
    }
    
    private var recordText: String {
        isRecording ? "정지" : question.isAnswered ? "다시 녹음하기" : "녹음하기"
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("질문: ")
                            .font(.headline)
                        
                        Text(question.content)
                            .font(.title.monospaced())
                            .minimumScaleFactor(0.3)
                            .frame(minHeight: geometry.size.height * 0.25)
                    }
                }
                .padding(.bottom, 30)
                
                if question.isAnswered && !isRecording {
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
                
                ColorButton(title: recordText , buttonColor: isRecording ? .nowRecording : .recordButton, textColor: .white) {
                    if isRecording {
                        (tempAnswerFileName, tempAnswerLength) = recordManager.stopRecord()
                        
                        if question.isAnswered {
                            isShowingRerecordAlert.toggle()
                        } else {
                            if let tempAnswerFileName, let tempAnswerLength {
                                question.answerFileName = tempAnswerFileName
                                question.answerLength = tempAnswerLength
                                question.lastAnsweredDate = Date()
                                
                                modelContext.insert(question)
                            }
                        }
                    } else {
                        recordManager.startRecord(questionID: question.id)
                    }
                }
                
                Spacer()
            }
            .padding(10)
        }
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingEditSheet.toggle()
                } label: {
                    Label("질문 수정", systemImage: "pencil.line")
                }
            }
        }
        .alert("답변을 저장할까요?", isPresented: $isShowingRerecordAlert) {
            Button("취소", role: .cancel) {
                if let tempAnswerFileName {
                    recordManager.deleteRecord(fileName: tempAnswerFileName)
                }
                
                tempAnswerLength = nil
                tempAnswerFileName = nil
                isShowingRerecordAlert = false
            }
            
            Button("확인") {
                if let tempAnswerFileName, let tempAnswerLength {
                    if let answerFileName = question.answerFileName {
                        recordManager.deleteRecord(fileName: answerFileName)
                    }
                    
                    question.answerFileName = tempAnswerFileName
                    question.answerLength = tempAnswerLength
                    question.lastAnsweredDate = Date()
                    
                    modelContext.insert(question)
                }
                
                isShowingRerecordAlert = false
            }
        } message: {
            Text("답변이 지금 녹음한 내용으로 변경되며, 이전에 녹음된 내용은 삭제됩니다.")
        }
        .sheet(isPresented: $isShowingEditSheet) {
            EditQuestionView(question: $question)
        }
    }
}
