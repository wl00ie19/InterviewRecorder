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
    
    private let dateConverter = DateConverter.shared
    
    @Published var status: RecordStatus = .stop
    @Published var errorMessage: ErrorType?
    @Published var audioLevel: CGFloat = 0.0
    
    /// 녹음 파일 목록
    var recordedFiles = [URL]()
    
    private var timer: Timer?
    
    private var startTime: TimeInterval = 0
    
    private var fileName: String = ""
    
    /// 녹음 진행 시간
    @Published var elapsedTime: Double = 0
    
    /// 녹음 시작 - 질문 ID 필요
    func startRecord(questionID: String) {
        stopPlay()
        
        let session = AVAudioSession.sharedInstance()
        errorMessage = nil
        
        do {
            try session.setCategory(.record, mode: .default)
            try session.setActive(true)
        } catch {
            errorMessage = .startFail
        }
        
        fileName = "\(questionID)_\(dateConverter.toFileNameString(date: Date())).m4a"
        
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            errorMessage = .startFail
            return
        }
        
        var fileURL = documentPath.appending(path: fileName)
        
        var fileIndex = 1
        
        // 파일 중복 확인
        while FileManager.default.fileExists(atPath: fileURL.path()) {
            fileName = "\(fileName)_\(fileIndex)"
            fileURL = documentPath.appending(path: fileName)
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
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                self.getAudiolevels()
                self.elapsedTime = Date().timeIntervalSince1970 - self.startTime
            }
        } catch {
            errorMessage = .startFail
        }
    }
    
    /// 오디오 음량 레벨 가져오기
    func getAudiolevels() {
        audioRecorder?.updateMeters()
        
        if let averagePower = audioRecorder?.averagePower(forChannel: 0) {
            audioLevel = pow(10, (CGFloat(averagePower / 50)))
        } else {
            audioLevel = 0.0
        }
    }
    
    /// 녹음 정지
    func stopRecord() -> (String, Double) {
        audioRecorder?.stop()
        timer?.invalidate()
        let length = elapsedTime
        audioLevel = 0.0
        resetStatus()
        
        if self.audioRecorder != nil {
            fetchData()
        }
        
        return (fileName, length)
    }
    
    /// 녹음 목록 새로고침
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
    
    /// 해당 파일명의 녹음 파일 재생 시작
    func startPlay(fileName: String) {
        errorMessage = nil
        
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            errorMessage = .playingFail
            return
        }
        
        let recordingURL = documentPath.appending(path: fileName)
        
        let session = AVAudioSession.sharedInstance()
        
        // 재생 시작
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            
            if let audioPlayer {
                audioPlayer.prepareToPlay()
                startTime = Date().timeIntervalSince1970
                audioPlayer.delegate = self
                audioPlayer.play()
                status = .play
                
                timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                    self.elapsedTime = Date().timeIntervalSince1970 - self.startTime
                }
            }
        } catch {
            errorMessage = .playingFail
        }
    }
    
    /// 재생 일시정지
    func pausePlay() {
        audioPlayer?.pause()
        status = .pause
        timer?.invalidate()
    }
    
    /// 재생 계속하기
    func resumePlay() {
        audioPlayer?.play()
        status = .play
        
        startTime = Date().timeIntervalSince1970 - elapsedTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            self.getAudiolevels()
            self.elapsedTime = Date().timeIntervalSince1970 - self.startTime
        }
    }
    
    /// 재생 중단
    func stopPlay() {
        audioPlayer?.stop()
        resetStatus()
    }
    
    /// 해당 URL의 녹음 파일 삭제
    func deleteRecord(fileName: String) {
        errorMessage = nil
        
        // 삭제 전 재생 및 녹음 정지
        if status != .stop {
            if status == .record {
                audioRecorder?.stop()
            }
            audioPlayer?.stop()
        }
        
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            errorMessage = .startFail
            return
        }
        
        let recordURL = documentPath.appending(path: fileName)
        
        do {
            try FileManager.default.removeItem(at: recordURL)
            recordedFiles.removeAll{ $0 == recordURL }
        } catch {
            errorMessage = .deleteFail
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        resetStatus()
    }
    
    private func resetStatus() {
        errorMessage = nil
        status = .stop
        elapsedTime = 0
        timer?.invalidate()
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
