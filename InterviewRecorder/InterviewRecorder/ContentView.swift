//
//  ContentView.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Question.questionDate) var questions: [Question]
    
    @EnvironmentObject var recordManager: AudioRecordManager
    
    @FocusState private var focused: Bool
    
    @State private var isShowingRecordAnswer: Bool = false
    
    @State private var isShowingNewQuestion: Bool = false
    
    @State private var isEditing: Bool = false
    
    @State private var isShowingDeleteAlert: Bool = false
    
    @State private var isShowingSaveAlert: Bool = false
    
    @State private var selectedQuestion: Question?
    
    @State private var tempAnswerFileName: String?
    
    @State private var tempAnswerLength: Double?
    
    @State private var searchText: String = ""
    
    @State private var isUnansweredOnly: Bool = false
    
    @State private var isSearchDisplaying: Bool = false
    
    @State private var randomQuestion: Question?
    
    private var filteredQuestions: [Question] {
        if isUnansweredOnly {
            searchText.isEmpty ? questions.filter{ $0.isAnswered == false }: questions.filter{ $0.content.contains(searchText) && $0.isAnswered == true }
        } else {
            searchText.isEmpty ? questions : questions.filter{ $0.content.contains(searchText) }
        }
    }
    
    var editButtonText: String {
        isEditing ? "완료" : "삭제"
    }
    
    var editIconName: String {
        isEditing ? "checkmark" : "trash"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    VStack(spacing: 10) {
                        if isSearchDisplaying {
                            SearchField(searchText: $searchText, isUnansweredOnly: $isUnansweredOnly)
                                .focused($focused)
                        }
                        
                        if let randomQuestion, searchText.isEmpty {
                            VStack(spacing: 30) {
                                Text("답변하지 않은 질문")
                                    .font(.headline)
                                
                                Text(randomQuestion.content)
                                    .font(.title.monospaced())
                                
                                ColorButton(title: "답변하기", buttonColor: .blue, textColor: .white, isDisabled: isEditing) {
                                    selectedQuestion = randomQuestion
                                    
                                    if selectedQuestion != nil {
                                        isShowingRecordAnswer.toggle()
                                    }
                                }
                            }
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .strokeBorder(Color(uiColor: .systemGray3), lineWidth: 2)
                            }
                        }
                        
                        ColorButton(title: "질문 추가하기", buttonColor: Color(uiColor: .systemGray5), isDisabled: isEditing) {
                            isShowingNewQuestion.toggle()
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(10)
                    
                    ForEach(filteredQuestions) { question in
                        QuestionCell(title: question.content, isEditing: $isEditing) {
                            selectedQuestion = question
                            
                            if selectedQuestion != nil {
                                isShowingRecordAnswer.toggle()
                            }
                        } deleteAction: {
                            selectedQuestion = question
                            isShowingDeleteAlert.toggle()
                        }
                    }
                }
                .padding(.vertical, 10)
                .background {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundStyle(.background)
                        .onTapGesture {
                            focused = false
                        }
                }
            }
            .navigationTitle("전체 답변 목록")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        selectedQuestion = nil
                        isEditing.toggle()
                    } label: {
                        Label(editButtonText, systemImage: editIconName)
                    }
                    .disabled(questions.isEmpty)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if isSearchDisplaying {
                            searchText = ""
                        }
                        
                        isSearchDisplaying.toggle()
                    } label: {
                        Label("검색", systemImage: "magnifyingglass")
                    }
                }
            }
            .navigationDestination(isPresented: $isShowingNewQuestion) {
                NewQuestionView(isShowingNewQuestion: $isShowingNewQuestion)
            }
            .navigationDestination(isPresented: $isShowingRecordAnswer) {
                if let selectedQuestion {
                    AnswerRecordingView(question: selectedQuestion, tempAnswerFileName: $tempAnswerFileName, tempAnswerLength: $tempAnswerLength)
                }
            }
        }
        .onAppear {
            randomQuestion = questions.filter{ $0.isAnswered == false }.isEmpty ? nil : questions.filter{ $0.isAnswered == false }.randomElement()
        }
        .onChange(of: $isShowingRecordAnswer.wrappedValue) {
            if !isShowingRecordAnswer {
                switch recordManager.status {
                case .record:
                    if selectedQuestion != nil {
                        (tempAnswerFileName, tempAnswerLength) = recordManager.stopRecord()
                        isShowingSaveAlert.toggle()
                    }
                case .play, .pause:
                    recordManager.stopPlay()
                case .stop:
                    break
                }
            }
        }
        .alert("질문을 삭제할까요?", isPresented: $isShowingDeleteAlert) {
            Button("취소", role: .cancel) {
                isShowingDeleteAlert = false
                selectedQuestion = nil
                isEditing = false
            }
            
            Button("삭제", role: .destructive) {
                if let selectedQuestion {
                    if let fileName = selectedQuestion.answerFileName {
                        recordManager.deleteRecord(fileName: fileName)
                        isEditing = false
                    }
                    modelContext.delete(selectedQuestion)
                }
                isShowingDeleteAlert = false
                if questions.isEmpty {
                    isEditing = false
                }
            }
        } message: {
            Text(selectedQuestion?.isAnswered ?? false ? "한번 삭제된 질문은 복구할 수 없으며, 녹음된 답변도 같이 삭제됩니다." : "한번 삭제된 질문은 복구할 수 없습니다.")
        }
        .alert("답변을 저장할까요?", isPresented: $isShowingSaveAlert) {
            Button("취소", role: .cancel) {
                if let tempAnswerFileName {
                    recordManager.deleteRecord(fileName: tempAnswerFileName)
                }
                selectedQuestion = nil
                tempAnswerFileName = nil
                tempAnswerLength = nil
                
                isShowingSaveAlert = false
            }
            
            Button("확인") {
                if let selectedQuestion, let tempAnswerFileName, let tempAnswerLength {
                    if let fileName = selectedQuestion.answerFileName {
                        recordManager.deleteRecord(fileName: fileName)
                    }
                    
                    selectedQuestion.answerFileName = tempAnswerFileName
                    selectedQuestion.answerLength = tempAnswerLength
                    selectedQuestion.lastAnsweredDate = Date()
                    
                    modelContext.insert(selectedQuestion)
                }
                
                selectedQuestion = nil
                tempAnswerFileName = nil
                tempAnswerLength = nil
                
                isShowingSaveAlert = false
            }
        } message: {
            Text(selectedQuestion?.isAnswered ?? false ? "답변이 지금 녹음한 내용으로 변경되며, 이전에 녹음된 내용은 삭제됩니다." : "저장하지 않으면 지금 녹음한 내용은 삭제됩니다.")
        }
    }
}

#Preview {
    ContentView()
}
