//
//  InterviewRecorderApp.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/15/24.
//

import SwiftUI
import SwiftData

@main
struct InterviewRecorderApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([Question.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let config = ModelConfiguration(cloudKitDatabase: .none)
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("SwiftData ModelContainer 오류: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
