//
//  CompleteTripPostData.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/12.
//

import Foundation

struct CompleteTripPostData: Codable {
    var token: String
    let planIdx: String
    let mapX: String
    let mapY: String
}
