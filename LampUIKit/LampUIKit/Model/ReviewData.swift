//
//  ReviewData.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/12.
//

import Foundation

struct ReviewData: Codable, Hashable {
    let reviewIdx: Int?
    let contentId: String
    let userId: Int?
    let star: String?
    let satisfaction: Int?
    let mood: Int?
    let surround: Int?
    let foodArea: Int?
    let content: String?
    let createdAt: String?
    let numReported: Int?
    let photoIdx: Int?
    var numLiked: Int
    let reviewILiked: Bool
    let photoUrlArray: [String]?
}
