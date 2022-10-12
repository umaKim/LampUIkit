//
//  ReviewPostData.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/12.
//

import Foundation

struct ReviewPostData: Codable {
    var token: String
    var contentId: String
    let contentTypeId: String
    let placeName: String
    let starRate: String
    let satisfaction: Int
    let mood: Int
    let surround: Int
    let foodArea: Int
    let content: String
}
