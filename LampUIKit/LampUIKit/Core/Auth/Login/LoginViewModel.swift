//
//  LoginViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//

import Foundation

enum LoginViewModelNotification: Notifiable {
    case changeRootViewController(String)
    case presentCreateNickName
    case presentInitialSetpage
}

class LoginViewModel: BaseViewModel<LoginViewModelNotification> {
    
    private let auth: Autheable
    private let network: Networkable
    
    init(
        _ auth: Autheable = AuthManager.shared,
        _ network: Networkable = NetworkManager()
    ) {
        self.auth = auth
        self.network = network
        super.init()
    }
    
    public func checkUserExist(_ uid: String) {
        network.checkUserExist(uid) {[weak self] res in
            guard let self = self else {return}
            if res.isSuccess {
                if res.nicknameExist ?? false {
                    self.network.setToken(uid)
                    self.sendNotification(.changeRootViewController(uid))
                } else {
                    self.sendNotification(.presentCreateNickName)
                }
                
            } else {
                self.sendNotification(.presentInitialSetpage)
            }
        }
    }
    
    public func setUserAuthType(_ type: UserAuthType) {
        auth.setUserAuthType(type)
    }
    
}
