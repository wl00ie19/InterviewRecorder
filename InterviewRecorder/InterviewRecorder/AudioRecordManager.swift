//
//  AudioRecordManager.swift
//  InterviewRecorder
//
//  Created by 이우석 on 8/15/24.
//

import Foundation
import AVFoundation

class AudioRecordManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioRecorder: AVAudioRecorder? = nil
    var audioPlayer: AVAudioPlayer? = nil
    
    @Published var status: RecordStatus = .stop
    @Published var errorMessage: ErrorType?
    @Published var audioLevel: CGFloat = 0.0
    
    var recordedFiles = [URL]()
    
    var timer: Timer?
    
    var startTime: TimeInterval = 0
    
    @Published var recordTime: Int = 0
    
    var minute: Int {
        recordTime / 60
    }
    
    var second: Int {
        recordTime % 60
    }
    
    func startRecord() {
        let session = AVAudioSession.sharedInstance()
        errorMessage = nil
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            errorMessage = .startFail
        }
        
        let fileName = dateToString(date: Date())
        
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            errorMessage = .startFail
            return
        }
        
        var fileURL = documentPath.appending(path: "\(fileName).m4a")
        
        var fileIndex = 1
        
        // 파일 중복 확인
        while FileManager.default.fileExists(atPath: fileURL.path()) {
            let newFileName = "\(fileName)_\(fileIndex)"
            fileURL = documentPath.appending(path: "\(newFileName).m4a")
            fileIndex += 1
        }
        
        // 녹음 포맷, 샘플링 레이트(Hz, 일반적으로 44100Hz), 채널 수 설정(1: 모노, 2: 스테레오)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // 녹음 시작
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            startTime = Date().timeIntervalSince1970
            audioRecorder?.record()
            status = .record
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                self.getAudiolevels()
                self.recordTime = Int(Date().timeIntervalSince1970 - self.startTime)
            }
        } catch {
            errorMessage = .startFail
        }
    }
    
    func getAudiolevels() {
        audioRecorder?.updateMeters()
        
        if let averagePower = audioRecorder?.averagePower(forChannel: 0) {
            audioLevel = pow(10, (CGFloat(averagePower / 50)))
        } else {
            audioLevel = 0.0
        }
    }
    
    func stopRecord() {
        audioRecorder?.stop()
        timer?.invalidate()
        recordTime = 0
        audioLevel = 0.0
        
        if self.audioRecorder != nil {
            fetchData()
            errorMessage = nil
            status = .stop
        }
    }
    
    func fetchData() {
        errorMessage = nil
        
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            errorMessage = .fetchFail
            return
        }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil)
            
            self.recordedFiles = contents
        } catch {
            errorMessage = .fetchFail
        }
    }
    
    func startPlay(recordingURL: URL) {
        errorMessage = nil
        
        // 재생 시작
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            if let audioPlayer {
                audioPlayer.prepareToPlay()
                audioPlayer.delegate = self
                audioPlayer.play()
                status = .play
            }
        } catch {
            errorMessage = .playingFail
        }
    }
    
    func pausePlay() {
        audioPlayer?.pause()
        status = .pause
    }
    
    func resumePlay() {
        audioPlayer?.play()
        status = .play
    }
    
    func stopPlay() {
        audioPlayer?.stop()
        errorMessage = nil
        status = .stop
    }
    
    func deleteRecord(offsets: IndexSet) {
        errorMessage = nil
               
        // 삭제 전 재생 및 녹음 정지
        if status != .stop {
            if status == .record {
                audioRecorder?.stop()
            }
            audioPlayer?.stop()
        }
        
        // 해당 index의 녹음 파일 지우기
        for index in offsets {
            let recordURL = recordedFiles[index]
            
            do {
                try FileManager.default.removeItem(at: recordURL)
            } catch {
                errorMessage = .deleteFail
            }
        }
        
        // 녹음 URL 목록 삭제
        recordedFiles.remove(atOffsets: offsets)
    }
    
    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        
        return dateFormatter.string(from: date)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        status = .stop
    }
}

enum ErrorType: String {
    case startFail = "녹음을 시작할 수 없습니다."
    case fetchFail = "녹음을 불러올 수 없습니다."
    case playingFail = "녹음을 재생할 수 없습니다."
    case deleteFail = "녹음을 삭제할 수 없습니다."
}

enum RecordStatus {
    case stop
    case record
    case play
    case pause
}
