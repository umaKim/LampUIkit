//
//  ReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import Foundation

class MyReviewsViewModel: BaseViewModel {
    
    private(set) lazy var datum: [UserReviewData] = [.init(date: "", title: "", comment: "", rate: "")]
    
    override init() {
        super.init()
        
    }
}

struct UserReviewData: Hashable {
    let date: String
    let title: String
    let comment: String
    let rate: String
}
