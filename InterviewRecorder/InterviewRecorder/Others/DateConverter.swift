//
//  DateConverter.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/29/24.
//

import Foundation

class DateConverter {
    static let shared = DateConverter()
    
    /// 앱 View에 표시되는 형식으로 변환
    func toDisplayString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    /// 녹음 파일명에 사용되는 형식으로 변환
    func toFileNameString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        
        return dateFormatter.string(from: date)
    }
    
    func toTimeString(elapsedTime: Double) -> String {
        let minute = Int(elapsedTime / 60)
        let second = Int(elapsedTime) % 60
        
        return second >= 10 ? "\(minute):\(second)" : "\(minute):0\(second)"
    }
}
