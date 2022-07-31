//
//  InitialQuizViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//

import UIKit

import Combine

class InitialQuizViewController: BaseViewContronller {
        bind()
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .button1:
                    break
                    
                case .button2:
                    break
                    
                case .button3:
                    break
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
