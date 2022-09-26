//
//  PostAddToMyTripData.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//

import Foundation

struct PostAddToMyTripData: Codable {
    var token: String
    let contentId: String
    let contentTypeId: String
    let image: String
    let placeName: String
    let placeInfo: String
    let placeAddress: String
    let userMemo: String
    let mapX: String
    let mapY: String
}
