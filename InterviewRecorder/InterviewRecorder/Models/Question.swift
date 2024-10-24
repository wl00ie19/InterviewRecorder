//
//  Question.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/15/24.
//

import Foundation
import SwiftData

@Model
class Question: Identifiable {
    /// 질문 ID
    private(set) var id: String
    
    /// 질문 내용
    var content: String
    
    /// 질문 등록 일자
    private(set) var questionDate: Date
    
    /// 답변 녹음 파일명
    var answerFileName: String?
    
    /// 답변 녹음 파일 길이
    var answerLength: Double?
    
    /// 마지막 답변 일자
    var lastAnsweredDate: Date?
    
    /// 답변 여부
    var isAnswered: Bool {
        answerFileName != nil
    }
    
    init(id: String, content: String, questionDate: Date) {
        self.id = id
        self.content = content
        self.questionDate = questionDate
    }
}
