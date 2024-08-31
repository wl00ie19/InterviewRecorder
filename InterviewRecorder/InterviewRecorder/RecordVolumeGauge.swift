//
//  RecordIndicator.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/29/24.
//

import SwiftUI

struct RecordVolumeGauge: View {
    @EnvironmentObject var recordManager: AudioRecordManager
    
    private let dateConverter = DateConverter.shared
    
    private var isRecording: Bool {
        recordManager.status == .record
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(width: geometry.size.width)
                    
                    if isRecording {
                        Rectangle()
                            .foregroundStyle(Color.volumeGauge)
                            .frame(width: geometry.size.width * recordManager.audioLevel)
                    }
                }
            }
            
            if isRecording {
                Label("녹음 중 - \(dateConverter.toTimeString(elapsedTime: recordManager.elapsedTime))", systemImage: "mic.circle.fill")
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .foregroundStyle(.background)
                    .font(.title2)
            } else {
                Text("답변하지 않은 질문입니다.")
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .foregroundStyle(.background)
                    .font(.title2)
            }
        }
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}
