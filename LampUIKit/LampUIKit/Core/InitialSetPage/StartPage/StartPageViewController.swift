//
//  StartPageViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//
import HapticManager
import KakaoSDKUser
import KakaoSDKAuth
import Firebase
import Combine
import CombineCocoa
import UIKit
import Lottie

class StartPageViewController: BaseViewController<StartPageView, StartPageViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    // MARK: - Bind
    private func bind() {
        bindContentView()
        bindViewModel()
    }
    private func bindContentView() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                switch action {
                case .startButtonDidTap:
                    HapticManager.shared.feedBack(with: .heavy)
                    self?.viewModel.start()
                }
            }
            .store(in: &cancellables)
    }
    private func bindViewModel() {
        viewModel
            .notifyPublisher
            .sink {[weak self] notification in
                switch notification {
                case .presentLoginViewController:
                    self?.present(
                        LoginViewController(LoginView(), LoginViewModel()),
                        transitionType: .fromTop,
                        animated: true,
                        pushing: true
                    )
                case .presentMain(id: let id):
                    self?.presentMain(with: id)
                }
            }
            .store(in: &cancellables)
    }
    private func presentMain(with uid: String) {
        let nav = UINavigationController(rootViewController: MainViewController(MainView(), MainViewModel()))
        present(nav,
                transitionType: .fromTop,
                animated: true, pushing: true)
    }
}
