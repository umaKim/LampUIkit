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
    var userAuthType: UserAuthType? { get }
    var token: String? { get }
    func setUserAuthType(_ userAuthType: UserAuthType)
    func setToken(_ token: String)
}

final class AuthManager: Autheable {
    static let shared = AuthManager()
    private(set) var userAuthType: UserAuthType?
    private(set) var token: String?
    public func setUserAuthType(_ userAuthType: UserAuthType) {
        self.userAuthType = userAuthType
    }
    public func setToken(_ token: String) {
        self.token = token
    }
}
