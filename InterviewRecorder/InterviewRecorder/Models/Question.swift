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
    let id: UUID
    let questionDate: Date
    let answerURLString: String?
    let lastAnsweredDate: Date?
    
    init(id: UUID, questionDate: Date, answerURLString: String?, lastAnsweredDate: Date?) {
        self.id = id
        self.questionDate = questionDate
        self.answerURLString = answerURLString
        self.lastAnsweredDate = lastAnsweredDate
    }
}
