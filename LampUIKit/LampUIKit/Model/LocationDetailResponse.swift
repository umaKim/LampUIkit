//
//  LocationDetailResponse.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/12.
//

import Foundation

struct LocationDetailResponse: Codable {
    let result: LocationDetailData?
}

struct LocationDetailData: Codable {
    let datailInfo: LocationDetailInfoData?
    let contentTypeId: String?
    var bookMark: Bool?
    let totalAvgReviewRate: TotalAvgReviewRate?
    let planExist: PlanExist?
}
