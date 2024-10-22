# 면접 연습 녹음기

- 취업을 준비하는 사용자가 직접 면접 질문을 입력하고 대답을 녹음할 수 있는 앱
- 토익 스피킹 등의 말하기 시험을 준비하는 사람들도 문제를 등록하고 답변을 녹음할 수 있는 앱

## 프로젝트 정보
### 주요 기능
- 직접 면접 질문을 등록하고 해당 질문에 대한 답변을 녹음할 수 있습니다. 
- 이미 등록한 질문을 수정하거나 삭제할 수 있습니다. 
- 답변을 잘못 녹음했을 때 다시 녹음할 수 있습니다. 
### 개발 기간
- 2024년 8월 15일 ~ 8월 27일 **앱 화면 구성 및 면접 질문 저장 기능 구현**
- 2024년 8월 29일 ~ 9월 10일, 9월 23일 ~ 10월 12일 **답변 녹음 및 재녹음 기능 구현**
### 개발 및 실행 환경
- iOS(iPadOS) 17+
- Swift 5.10
- Xcode 15.4
  (Xcode 16에서 실행 시 Swift 5 모드로 실행이 필요합니다.)
### 사용 프레임워크
- `SwiftUI` (일부 `UIKit` 기능 사용)
- `SwiftData`
- `Foundation` (File Manager)
- `AVFoundation`
### 스크린샷

| **비어 있는 목록** | **질문 등록 이후 목록(답변하지 않은 질문이 있을 때)** |
| :---: | :---: |
| <img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/EmptyList.png?raw=true" width="80%"> | <img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/QuestionList.png?raw=true" width="80%"> | 
| **질문 검색** | **질문 삭제** |
| <img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/Search.png?raw=true" width="80%"> | <img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/DeleteList.png?raw=true" width="80%"> | 
| **새로운 질문 추가** | **답변하지 않은 질문** |
|<img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/NewQuestion.png?raw=true" width="80%">|<img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/UnansweredQuestion.png?raw=true" width="80%">|
| **답변 녹음** | **답변한 질문** |
|<img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/AnswerRecording.png?raw=true" width="80%">|<img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/AnsweredQuestion.png?raw=true" width="80%">|
| **답변 재생** | **질문 수정** |
|<img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/AnswerPlaying.png?raw=true" width="80%">|<img src="https://github.com/wl00ie19/InterviewRecorder/blob/main/Images/EditQuestion.png?raw=true" width="80%">|

## Notice
앱 관련 문의사항이 있으시면 아래 주소로 연락 부탁드립니다. 
```
wl00ie19@gmail.com
```

## License
Copyright (c) 2024 **Wooseok Lee**. All rights reserved.

Licensed under the [MIT](LICENSE) license.
