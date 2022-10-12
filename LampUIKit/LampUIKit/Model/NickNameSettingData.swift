//
//  NickNameSettingData.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/12.
//

import Foundation

struct NickNameSettingData: Encodable {
    let nickname: String
    let socialToken: String
    let isAdmin: Int
}
