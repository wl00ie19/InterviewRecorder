//
//  RecordIndicator.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/29/24.
//

import SwiftUI

struct RecordVolumeGauge: View {
    var body: some View {
        @State var volumeLevel = 0.60
        
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(width: geometry.size.width)
                    Rectangle()
                        .foregroundStyle(.green)
                        .frame(width: geometry.size.width * volumeLevel)
                }
            }
            
            Label("녹음 중 - 0:01", systemImage: "mic.circle.fill")
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .foregroundStyle(.background)
                .font(.title)
        }
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    RecordVolumeGauge()
}
