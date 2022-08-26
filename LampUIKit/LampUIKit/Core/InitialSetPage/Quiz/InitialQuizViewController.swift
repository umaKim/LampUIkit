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
            .sink {[unowned self] action in
                HapticManager.shared.feedBack(with: .heavy)
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
            .sink {[unowned self] noti in
                switch noti {
                case .index(let index):
                    print(index)
                    
                case .quizData(let data):
                    self.contentView.setQuizData(data)
                    
                case .setCharacter(let data):
                    self.contentView.setCharacterData(data)
                    
                case .finishInitialQuiz:
                    self.present(CreateNickNameViewController(CreateNickNameViewModel()), transitionType: .fromTop, animated: true, pushing: true)
                    
                case .setInitialSetting(let bool):
                    self.isInitialSettingDone(bool)
                case .setTags(let tags):
                    self.contentView.setTags(tags)
                }
            }
            .store(in: &cancellables)
    }
}
