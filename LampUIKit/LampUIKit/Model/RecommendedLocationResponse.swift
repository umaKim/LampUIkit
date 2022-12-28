//
//  RecommendedLocationResponse.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import Foundation

struct RecommendedLocationResponse: Codable, Hashable {
    let result: [RecommendedLocation]
}

struct RecommendedLocation: Codable, Hashable {
    var uid = UUID()
    let image: String?
    let contentId: String
    let contentTypeId: String
    let title: String
    let addr: String
    let rate: Float?
    let bookMarkIdx: String?
    var isBookMarked: Bool
    let mapX: String
    let mapY: String
    let planIdx: String?
    var isOnPlan: Bool?
    let travelCompletedDate: String?
}
