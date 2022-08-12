//
//  LoginUserData.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import Foundation

struct LoginUserData: Codable {
    let email: String
    let nickname: String
    let name: String
    let socialToken: String
    let isAdmin: Bool
}
