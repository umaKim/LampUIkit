//
//  StartPageViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//
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
    
    //MARK: - Bind
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                switch action {
                case .startButtonDidTap:
                    HapticManager.shared.feedBack(with: .heavy)
                    if AuthApi.hasToken() {
                        UserApi.shared.me {[weak self] user, error in
                            guard
                                let id = user?.id else {
                                self?.present(
                                    LoginViewController(LoginView(), LoginViewModel()),
                                    transitionType: .fromTop,
                                    animated: true,
                                    pushing: true
                                )
                                return
                            }
                            self?.viewModel.setUserAuthType(.kakao)
                            self?.presentMain(with: "\(id)")
                        }
                    }
                    else if let currentUser = Auth.auth().currentUser {
                        for userInfo in currentUser.providerData {
                            switch userInfo.providerID {
                            case "apple.com":
                                self?.viewModel.setUserAuthType(.apple)
                                
                            case "google.com":
                                self?.viewModel.setUserAuthType(.google)
                                
                            default:
                                print("user is signed in with \(userInfo.providerID)")
                                self?.viewModel.setUserAuthType(.firebase)
                            }
                        }
                        self?.presentMain(with: currentUser.uid)
                        
                    } else {
                        self?.present(
                            LoginViewController(LoginView(), LoginViewModel()),
                            transitionType: .fromTop,
                            animated: true,
                            pushing: true
                        )
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func presentMain(with uid: String) {
        viewModel.setToken(uid)
        let nav = UINavigationController(rootViewController: MainViewController(MainView(), MainViewModel()))
        present(nav,
                transitionType: .fromTop,
                animated: true, pushing: true)
    }
    
}
