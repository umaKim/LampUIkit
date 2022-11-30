//
//  LoginViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//
import Firebase
import Foundation

enum LoginViewModelNotification: Notifiable {
    case changeRootViewController(String)
    case presentCreateNickName
    case presentInitialSetpage
    case showMessage(String)
}

class LoginViewModel: BaseViewModel<LoginViewModelNotification> {
    private let auth: Autheable
    private let network: Networkable
    // MARK: - Init
    init(
        _ auth: Autheable = AuthManager.shared,
        _ network: Networkable = NetworkManager()
    ) {
        self.auth = auth
        self.network = network
        super.init()
    }
    public func checkUserExist(_ uid: String) {
        network.get(.checkUserExist(uid), UserExistCheckResponse.self) {[weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    if response.nicknameExist ?? false {
                        self.auth.setToken(uid)
                        self.sendNotification(.changeRootViewController(uid))
                    } else {
                        self.sendNotification(.presentCreateNickName)
                    }
                } else {
                    self.sendNotification(.presentInitialSetpage)
                }
            case .failure(let error):
                self.sendNotification(.showMessage(error.localizedDescription))
            }
        }
    }
    public func setUserAuthType(_ type: UserAuthType) {
        auth.setUserAuthType(type)
    }
}
