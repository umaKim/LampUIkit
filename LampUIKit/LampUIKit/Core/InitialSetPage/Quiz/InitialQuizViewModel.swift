//
//  InitialQuizViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/01.
//
import Combine
import UIKit

enum InitialQuizViewModelNotification: Notifiable {
    case index(String)
    case quizData(Question)
    case setCharacterImage(UIImage)
    case finishInitialQuiz
}

enum InitialQuizViewStatus {
    case quiz
    case result
}

class InitialQuizViewModel: BaseViewModel<InitialQuizViewModelNotification> {
    private let characterImages: [UIImage?] = [
        .init(named: "resultRacoon".localized),
        .init(named: "resultRabbit".localized),
        .init(named: "resultCat".localized),
        .init(named: "resultDog".localized),
        .init(named: "resultBear".localized)
    ]
    
    private var questions: [Question] = []
    private var answers: [UserQuizeAnswer] = []
    
    private var status: InitialQuizViewStatus = .quiz
    
    private let network: Networkable
    
    //MARK: - Init
    init(
        _ network: Networkable = NetworkManager()
    ) {
        self.network = network
        super.init()
        
        fetch()
    }
    
    private var currentIndex: Int = 0
    
    private func fetch() {
        network.get(.fetchQuestions, [Question].self) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let questions):
                self.questions = questions
                self.currentIndex = 0
                self.sendNotification(.quizData(self.questions[self.currentIndex]))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func answerChoice(_ answer: Int) {
        answers.removeAll(where: {$0.questionId == self.currentIndex})
        answers.append(.init(questionId: currentIndex, answer: answer))
    }
    
    public func next() {
        switch status {
        case .quiz:
            quizProcess()
            
        case .result:
            resultProcess()
        }
    }
    
    private func quizProcess() {
        if currentIndex != 5 {
            if answers.contains(where: {$0.questionId == self.currentIndex}) {
                currentIndex += 1
                sendNotification(.quizData(self.questions[currentIndex]))
            } else {
                //TODO: show alert
                print("please choose something")
            }
        } else {
            network.post(.postAnswers, answers, CharacterResponse.self) {[weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let response):
                    self.status = .result
                    
                    if let image = self.characterImages[response.result.characterChosen ?? 0] {
                        self.sendNotification(.setCharacterImage(image))
                    } else {
                        if let image: UIImage = .placeholder {
                            self.sendNotification(.setCharacterImage(image))
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func resultProcess() {
        self.sendNotification(.finishInitialQuiz)
    }
}
