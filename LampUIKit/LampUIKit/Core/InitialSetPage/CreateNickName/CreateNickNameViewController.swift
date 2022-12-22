//
//  CreateNickNameViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//
import HapticManager
import UmaBasicAlertKit
import Combine
import UIKit

final class CreateNickNameViewController: BaseViewController<CreateNickNameView, CreateNickNameViewModel>, Alertable {
    override func loadView() {
        super.loadView()
        view = contentView.baseView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkNavy
        hideKeyboardWhenTappedAround()
        isInitialSettingDone(false)
        bind()
    }
}

// MARK: - Bind
extension CreateNickNameViewController {
    private func bind() {
        bind(with: contentView)
        bind(with: viewModel)
    }
    private func bind(with contentView: CreateNickNameView) {
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
                case .doneKeyboard:
                    self.view.endEditing(true)
                }
            }
            .store(in: &cancellables)
    }
    private func bind(with viewModel: CreateNickNameViewModel) {
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .moveToMain:
                    self.changeRoot(MainViewController(MainView(), MainViewModel()))
                case .errorMessage(let message):
                    self.showDefaultAlert(title: message.localized)
                case .setInitialSetting(let bool):
                    self.isInitialSettingDone(bool)
                case .isEnableConfirmButton(let isEnable):
                    self.contentView.isEnabledCreateAccountButton = isEnable
                }
            }
        .store(in: &cancellables)
    }
}
