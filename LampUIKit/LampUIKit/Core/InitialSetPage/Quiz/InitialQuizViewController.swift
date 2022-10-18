//
//  InitialQuizViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//

import UIKit
import Combine

class InitialQuizViewController: BaseViewController<InitialQuizView, InitialQuizViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isInitialSettingDone(false)
        bind()
    }
    
    //MARK: - Bind
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
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
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .index(let index):
                    print(index)
                    
                case .quizData(let data):
                    self.contentView.setQuizData(data)
                    
                case .setCharacterImage(let image):
                    self.contentView.setCharacterImage(image)
                    
                case .finishInitialQuiz:
                    self.present(CreateNickNameViewController(CreateNickNameView(), CreateNickNameViewModel()), transitionType: .fromTop, animated: true, pushing: true)
                    
                }
            }
            .store(in: &cancellables)
    }
}
