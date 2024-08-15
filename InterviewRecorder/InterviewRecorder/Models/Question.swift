//
//  Question.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/15/24.
//

import Foundation
import SwiftData

@Model
class Question {
    /// 질문 ID
    let id: UUID
    
    /// 질문 내용
    let content: String
    
    /// 질문 등록 일자
    let questionDate: Date
    
    /// 답변 녹음 파일 URL
    let answerURLString: String?
    
    /// 답변 녹음 파일 길이
    let answerLength: Double?
    
    /// 마지막 답변 일자
    let lastAnsweredDate: Date?
    
    /// 답변 여부
    var isAnswered: Bool {
        answerURLString != nil
    }
    
    init(id: UUID, content: String, questionDate: Date) {
        self.id = id
        self.content = content
        self.questionDate = questionDate
    }
}
