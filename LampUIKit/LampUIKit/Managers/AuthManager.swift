//
//  AuthManager.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/09.
//

import UIKit

enum UserAuthType {
    case kakao
    case firebase
    case google
    case apple
}

protocol Autheable {
    func setUserAuthType(_ userAuthType: UserAuthType)
}

final class AuthManager: Autheable {
    static let shared = AuthManager()
    
    private(set) var userAuthType: UserAuthType?
    
    public func setUserAuthType(_ userAuthType: UserAuthType) {
        self.userAuthType = userAuthType
    }
}
