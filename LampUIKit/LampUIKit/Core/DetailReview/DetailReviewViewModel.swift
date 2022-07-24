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
    
    private(set) var models: [ReviewModel] = [.init(imageUrl: "", rating: "", comments: "")]
}
