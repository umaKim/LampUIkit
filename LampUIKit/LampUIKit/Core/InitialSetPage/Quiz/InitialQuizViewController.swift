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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isInitialSettingDone(false)
    }
    
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
                    self.present(CreateNickNameViewController(CreateNickNameViewModel()), transitionType: .fromTop, animated: true, pushing: true)
                    
                }
            }
            .store(in: &cancellables)
    }
}
