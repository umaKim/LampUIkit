//
//  CreateNickNameViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//

import Combine
import Foundation

enum CreateNickNameViewModelNotify {
    case moveToMain
    case errorMessage(String)
    case setInitialSetting(Bool)
    case isEnableConfirmButton(Bool)
}

class CreateNickNameViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<CreateNickNameViewModelNotify, Never>()
    
    private var nickName: String = ""
    
    override init() {
        super.init()
        
//        notifySubject.send(.setInitialSetting(false))
    }
    
    public func createAccount() {
        NetworkService.shared.postNickName(nickName) { result in
            switch result {
            case .success(let response):
                if response.isSuccess ?? false {
                    self.notifySubject.send(.setInitialSetting(true))
                    self.notifySubject.send(.moveToMain)
                } else {
                    self.notifySubject.send(.errorMessage(response.message ?? ""))
                }
                
            case .failure(let error):
                self.notifySubject.send(.errorMessage(error.localizedDescription))
            }
        }
    }
    
    public func textDidChange(to text: String) {
        self.nickName = text
        self.notifySubject.send(.isEnableConfirmButton(!nickName.isEmpty))
    }
}
