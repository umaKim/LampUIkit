//
//  StartPageViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/25.
//
import AuthManager
import LampNetwork
import KakaoSDKUser
import KakaoSDKAuth
import Firebase
import Foundation

enum StartPageViewModelNotification: Notifiable {
    case presentLoginViewController
    case presentMain(id: String)
}

final class StartPageViewModel: BaseViewModel<StartPageViewModelNotification> {
    private let auth: Autheable
    private let network: Networkable
    // MARK: - Init
    init(
        auth: Autheable = AuthManager.shared,
        network: Networkable = NetworkManager()
    ) {
        self.auth = auth
        self.network = network
    }
    // MARK: - Public
    public func start() {
        if AuthApi.hasToken() {
            presentMainWithKakao()
        } else if let currentUser = Auth.auth().currentUser {
            presentMainWithFireBase(currentUser)
        } else {
            sendNotification(.presentLoginViewController)
        }
    }
}

// MARK: - Private
private extension StartPageViewModel {
    func setUserAuthType(_ type: UserAuthType) {
        auth.setUserAuthType(type)
    }
    func setToken(_ token: String) {
        auth.setToken(token)
    }
    func presentMainWithKakao() {
        UserApi.shared.me {[weak self] user, _ in
            guard
                let id = user?.id else {
                self?.sendNotification(.presentLoginViewController)
                return
            }
            self?.setUserAuthType(.kakao)
            self?.setToken("\(id)")
            self?.sendNotification(.presentMain(id: "\(id)"))
        }
    }
    func presentMainWithFireBase(_ currentUser: Firebase.User) {
        for userInfo in currentUser.providerData {
            switch userInfo.providerID {
            case "apple.com":
                self.setUserAuthType(.apple)
            case "google.com":
                self.setUserAuthType(.google)
            default:
                print("user is signed in with \(userInfo.providerID)")
                self.setUserAuthType(.firebase)
            }
        }
        self.setToken(currentUser.uid)
        self.sendNotification(.presentMain(id: currentUser.uid))
    }
}
