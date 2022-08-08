//
//  DetailReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//

import Foundation

class DetailReviewViewModel: BaseViewModel {
    override init() {
        super.init()
        
    }
    
    private(set) var models: [ReviewModel] = [
        .init(imageUrl: "1", rating: "", comments: ""),
        .init(imageUrl: "2", rating: "", comments: ""),
        .init(imageUrl: "3", rating: "", comments: ""),
        .init(imageUrl: "4", rating: "", comments: ""),
        .init(imageUrl: "5", rating: "", comments: ""),
        .init(imageUrl: "6", rating: "", comments: ""),
        .init(imageUrl: "7", rating: "", comments: ""),
        .init(imageUrl: "8", rating: "", comments: ""),
        .init(imageUrl: "9", rating: "", comments: ""),
    ]
}
