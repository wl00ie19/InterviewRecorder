//
//  Color+Extension.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/30/24.
//

import SwiftUI

public extension Color {
    /// 녹음 음량 표시 색상
    static let volumeGauge: Color = Color(red: 48/255, green: 240/255, blue: 0/255)
    /// 재생 버튼 색상
    static let playButton: Color = Color(red: 0/255, green: 146/255, blue: 50/255)
    /// 재생 중 색상
    static let nowPlaying: Color = Color(red: 41/255, green: 205/255, blue: 0/255)
    /// 녹음 버튼 색상
    static let recordButton: Color = Color(red: 255/255, green: 108/255, blue: 46/255)
    /// 녹음 중 색상
    static let nowRecording: Color = Color(red: 255/255, green: 160/255, blue: 17/255)
}
