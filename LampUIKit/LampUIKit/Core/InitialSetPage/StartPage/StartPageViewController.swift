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
                                self?.present(LoginViewController(vm: LoginViewModel()),
                                              transitionType: .fromTop,
                                              animated: true,
                                              pushing: true)
                                return
                            }
                            NetworkManager.shared.setUserAuthType(.kakao)
                            self?.presentMain(with: "\(id)")
                        }
                    }
                    else if let uid = Auth.auth().currentUser?.uid {
                        NetworkManager.shared.setUserAuthType(.firebase)
                        self?.presentMain(with: uid)
                    } else {
                        self?.present(LoginViewController(vm: LoginViewModel()),
                                      transitionType: .fromTop,
                                      animated: true,
                                      pushing: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func presentMain(with uid: String) {
        NetworkManager.shared.setToken(uid)
        let nav = UINavigationController(rootViewController: MainViewController(MainView(), MainViewModel()))
        present(nav,
                transitionType: .fromTop,
                animated: true, pushing: true)
    }
    
}
