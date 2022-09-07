//
//  ReviewDetailViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/05.
//

import Foundation

class ReviewDetailViewModel: BaseViewModel {
    
    private(set) var data: ReviewData
    
    init(_ data: ReviewData) {
        self.data = data
        super.init()
    }
}
