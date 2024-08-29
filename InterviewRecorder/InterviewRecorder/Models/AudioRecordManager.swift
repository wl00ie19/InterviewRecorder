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
    
    /// 녹음 진행 시간
    @Published var recordTime: Int = 0
    
    /// 녹음 진행 시간(분)
    var minute: Int {
        recordTime / 60
    }
    
    /// 녹음 진행 시간(초)
    var second: Int {
        recordTime % 60
    }
    
    /// 녹음 시작 - 질문 ID 필요
    func startRecord(questionID: String) {
        let session = AVAudioSession.sharedInstance()
        errorMessage = nil
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            errorMessage = .startFail
        }
        
        let fileName = questionID + dateConverter.toFileNameString(date: Date())
        
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
    
    /// 해당 URL의 녹음 파일 재생 시작
    func startPlay(fileURLString: String) {
        errorMessage = nil
        
        // 재생 시작
        if let recordingURL = URL(string: fileURLString) {
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
        } else {
            errorMessage = .playingFail
        }
    }
    
    /// 재생 일시정지
    func pausePlay() {
        audioPlayer?.pause()
        status = .pause
    }
    
    /// 재생 계속하기
    func resumePlay() {
        audioPlayer?.play()
        status = .play
    }
    
    /// 재생 중단
    func stopPlay() {
        audioPlayer?.stop()
        errorMessage = nil
        status = .stop
    }
    
    /// 해당 URL의 녹음 파일 삭제
    func deleteRecord(fileURLString: String) {
        errorMessage = nil
        
        // 삭제 전 재생 및 녹음 정지
        if status != .stop {
            if status == .record {
                audioRecorder?.stop()
            }
            audioPlayer?.stop()
        }
        
        // 해당 URL의 녹음 파일 지우기, 녹음 URL 목록 삭제
        if let recordURL = URL(string: fileURLString) {
            do {
                try FileManager.default.removeItem(at: recordURL)
                recordedFiles.removeAll{ $0 == recordURL }
            } catch {
                errorMessage = .deleteFail
            }
        } else {
            errorMessage = .playingFail
        }
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
