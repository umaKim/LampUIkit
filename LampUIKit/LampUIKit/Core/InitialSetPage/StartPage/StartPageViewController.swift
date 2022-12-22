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

final class StartPageViewController: BaseViewController<StartPageView, StartPageViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    private func presentMain(with uid: String) {
        let nav = UINavigationController(rootViewController: MainViewController(MainView(), MainViewModel()))
        present(nav,
                transitionType: .fromTop,
                animated: true, pushing: true)
    }
}

// MARK: - Bind
extension StartPageViewController {
    private func bind() {
        bind(with: contentView)
        bind(with: viewModel)
    }
    private func bind(with startPageView: StartPageView) {
        startPageView
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
    private func bind(with viewModel: StartPageViewModel) {
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
}
