//
//  Response.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import Foundation

struct Response: Codable {
    let isSuccess: Bool?
    let message: String?
struct CharacterResponse: Codable {
    let isSuccess: Bool?
    let message: String?
    let result: CharacterResult
}

    let characterChosen: Int?
}

struct UserExistCheckResponse: Codable {
    let isSuccess: Bool
    let nicknameExist: Bool?
    let userIdx: Int?
}
