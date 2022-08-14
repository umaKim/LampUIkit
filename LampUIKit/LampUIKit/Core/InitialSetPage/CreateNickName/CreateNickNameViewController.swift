//
//  CreateNickNameViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//

import UIKit

class CreateNickNameViewController: BaseViewContronller {

    private let contentView = CreateNickNameView()
    
    private let viewModel: CreateNickNameViewModel
    
    init(_ vm: CreateNickNameViewModel) {
        self.viewModel = vm
        super.init()
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

        view.backgroundColor = .darkNavy
        
        hideKeyboardWhenTappedAround()
        
        isInitialSettingDone(false)
        
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .createAccountButtonDidTap:
                    self.viewModel.createAccount()
                    
                case .textFieldDidChange(let text):
                    self.viewModel.textDidChange(to: text)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink { noti in
                switch noti {
                case .moveToMain:
                    self.changeRoot(MainViewController(MainViewModel()))
                    
                case .errorMessage(let message):
                    print(message)
                    //TODO: - show alert message
                    
                case .setInitialSetting(let bool):
                    self.isInitialSettingDone(bool)
                }
            }
        .store(in: &cancellables)
    }
}
