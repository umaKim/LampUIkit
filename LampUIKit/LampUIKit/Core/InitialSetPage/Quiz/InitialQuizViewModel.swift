//
//  InitialQuizViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/01.
//
import Combine
import UIKit

enum InitialQuizViewModelNotify {
    case question(String)
    case index(String)
    case answers(String, String, String)
}

class InitialQuizViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<InitialQuizViewModelNotify, Never>()
    
    private let characterImages: [UIImage?] = [
        .init(named: "bear"),
        .init(named: "cat"),
        .init(named: "racoon"),
        .init(named: "dog"),
        .init(named: "rabbit"),
    ]
    
    
    private lazy var characters: [CharacterData] = [.init(characterName: "Bear",
                                                     level: "1",
                                                     image: characterImages[0],
                                                     averageStat: "",
                                                     mileage: "",
                                                     gaugeDatum: []),
                                               
                                               .init(characterName: "Cat",
                                                     level: "1",
                                                     image: characterImages[1],
                                                     averageStat: "",
                                                     mileage: "",
                                                     gaugeDatum: []),
                                               
                                                .init(characterName: "Racoon",
                                                      level: "1",
                                                      image: characterImages[2],
                                                      averageStat: "",
                                                      mileage: "",
                                                      gaugeDatum: []),
                                               
                                               .init(characterName: "Dog",
                                                     level: "1",
                                                     image: characterImages[3],
                                                     averageStat: "",
                                                     mileage: "",
                                                     gaugeDatum: []),
                                               
                                               .init(characterName: "Rabbit",
                                                     level: "1",
                                                     image: characterImages[4],
                                                     averageStat: "",
                                                     mileage: "",
                                                     gaugeDatum: [])]
    
    override init() {
        super.init()
        
        fetch()
    }
    
    private func fetch() {
        //TODO: Bind with network
    public func answerChoice(_ answer: Int) {
        answers.removeAll(where: {$0.questionId == self.currentIndex})
        answers.append(.init(questionId: currentIndex, answer: answer))
    }
    
    public func next() {
        switch status {
        case .quiz:
//            notifySubject.send(.setInitialSetting(false))
            quizProcess()
            
        case .result:
//            notifySubject.send(.setInitialSetting(false))
            resultProcess()
        }
    }
    
    private func quizProcess() {
        if currentIndex != 5 {
            if answers.contains(where: {$0.questionId == self.currentIndex}) {
                currentIndex += 1
                notifySubject.send(.quizData(self.questions[currentIndex]))
            } else {
                //TODO: show alert
                print("please choose something")
            }
        } else {
            //MARK: - post answers after answering all questions
            NetworkService.shared.postAnswers(answers) { result in
                switch result {
                case .success(let response):
                    self.status = .result
                    
                    if let image = self.characterImages[response.result.characterChosen ?? 0] {
                        self.notifySubject.send(.setCharacterImage(image))
                        self.notifySubject.send(.setTags(response.result.tags))
                    } else {
                        self.notifySubject.send(.setCharacterImage(UIImage(named: "placeholder")!))
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    }
}
