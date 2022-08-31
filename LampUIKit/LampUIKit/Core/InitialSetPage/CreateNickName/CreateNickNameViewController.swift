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
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .createAccountButtonDidTap:
                    HapticManager.shared.feedBack(with: .heavy)
                    self.viewModel.createAccount()
                    
                case .textFieldDidChange(let text):
                    HapticManager.shared.feedBack(with: .soft)
                    self.viewModel.textDidChange(to: text)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .moveToMain:
                    self.changeRoot(MainViewController(MainViewModel()))
                    
                case .errorMessage(let message):
                    self.presentUmaDefaultAlert(title: message)
                    
                case .setInitialSetting(let bool):
                    self.isInitialSettingDone(bool)
                    
                case .isEnableConfirmButton(let isEnable):
                    self.contentView.isEnabledCreateAccountButton = isEnable
                }
            }
        .store(in: &cancellables)
    }
}
