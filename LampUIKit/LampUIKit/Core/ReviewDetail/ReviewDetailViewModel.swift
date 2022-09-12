//
//  ReviewDetailViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/05.
//

import Foundation

struct ReviewDetailData {
    let photoUrlArray: [String]
    let content: String
}

class ReviewDetailViewModel: BaseViewModel {
    
    private(set) var data: ReviewDetailData
    
    init(_ data: ReviewDetailData) {
        self.data = data
        super.init()
    }
}
