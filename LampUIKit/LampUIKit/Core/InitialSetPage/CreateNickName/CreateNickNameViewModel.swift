//
//  CreateNickNameViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//

import Combine
import Foundation

enum CreateNickNameViewModelNotification: Notifiable {
    case moveToMain
    case errorMessage(String)
    case setInitialSetting(Bool)
    case isEnableConfirmButton(Bool)
}

class CreateNickNameViewModel: BaseViewModel<CreateNickNameViewModelNotification> {
    
    private var nickName: String = ""
    
    private let network: Networkable
    
    init(
        _ network: Networkable = NetworkManager.shared
    ) {
        self.network = network
        super.init()
    }
    
    public func createAccount() {
        network.postNickName(nickName) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                if response.isSuccess ?? false {
                    self.sendNotification(.setInitialSetting(true))
                    self.sendNotification(.moveToMain)
                } else {
                    self.sendNotification(.errorMessage(response.message ?? ""))
                }
                
            case .failure(let error):
                self.sendNotification(.errorMessage(error.localizedDescription))
            }
        }
    }
    
    public func textDidChange(to text: String) {
        self.nickName = text
        self.sendNotification(.isEnableConfirmButton(!nickName.isEmpty))
    }
}
