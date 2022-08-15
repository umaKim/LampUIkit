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
    }
}
