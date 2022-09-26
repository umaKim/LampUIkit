//
//  UserReviewData.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//

import Foundation

struct UserReviewData: Codable, Hashable {
    let userId: Int
    let contentId: String
    let reviewIdx: Int
    let date: String
    let contentTypeId: String
    let placeName: String
    let star: String
    let content: String
    let photoUrl: [String]
}
