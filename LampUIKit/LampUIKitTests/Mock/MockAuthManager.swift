//
//  MockAuthManager.swift
//  LampUIKitTests
//
//  Created by 김윤석 on 2022/10/19.
//

import Foundation
@testable import LampUIKit

class MockAuthManager: Autheable {
    private(set) var userAuthType: LampUIKit.UserAuthType?
    
    private(set) var token: String?
    
    func setUserAuthType(_ userAuthType: LampUIKit.UserAuthType) {
        self.userAuthType = userAuthType
    }
    
    func setToken(_ token: String) {
        self.token = token
    }
}
