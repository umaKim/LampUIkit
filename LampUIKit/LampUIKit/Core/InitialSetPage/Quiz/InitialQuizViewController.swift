//
//  InitialQuizViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//

import UIKit

import Combine

class InitialQuizViewController: BaseViewContronller {

    private let contentView = InitialQuizView()
    
    private let viewModel: InitialQuizViewModel
    
    init(vm: InitialQuizViewModel) {
        self.viewModel = vm
        super.init()
     
        NetworkService.shared.login()
        
        bind()
    }
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .button1:
                    self.viewModel.answerChoice(1)
                    
                case .button2:
                    self.viewModel.answerChoice(2)
                    
                case .button3:
                    self.viewModel.answerChoice(3)
                    
                case .button4:
                    self.viewModel.answerChoice(4)
                    
                case .button5:
                    self.viewModel.answerChoice(5)
                    
                case .next:
                    self.viewModel.next()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink { noti in
                switch noti {
                case .question(let text):
                    print(text)
                case .index(let index):
                    print(index)
                case .answers(let answer1, let answer2, let answer3):
                    print(answer1)
                    print(answer2)
                    print(answer3)
                }
            }
            .store(in: &cancellables)
    }
}
