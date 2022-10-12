//
//  MyCharacter.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/12.
//

import Foundation

struct MyCharacter: Codable {
    let nickName: String
    let points: Int
    let travelExp: Int
    let exploreExp: Int
    let socialExp: Int
    let characterLevel: Int
    let totalExp: Int
    let avgExp: Int
    let characterImageUrl: String
}
