//
//  StartPageViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/25.
//

import Foundation

enum StartPageViewModelNotification: Notifiable {
    
}

final class StartPageViewModel: BaseViewModel<StartPageViewModelNotification> {
    
    private let auth: Autheable
    private let network: Networkable
    
    init(
        auth: Autheable = AuthManager.shared,
        network: Networkable = NetworkManager()
    ) {
        self.auth = auth
        self.network = network
    }
    
    public func setUserAuthType(_ type: UserAuthType) {
        auth.setUserAuthType(type)
    }
    
    public func setToken(_ token: String) {
        auth.setToken(token)
    }
}
