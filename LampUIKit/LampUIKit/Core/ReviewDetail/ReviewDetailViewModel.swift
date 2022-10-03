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

enum ReviewDetailViewModelNotification: Notifiable {
    
}

class ReviewDetailViewModel: BaseViewModel<ReviewDetailViewModelNotification> {
    
    private(set) var data: ReviewDetailData
    private let network: Networkable
    
    init(
        _ data: ReviewDetailData,
        _ network: Networkable = NetworkManager.shared
    ) {
        self.data = data
        self.network = network
        super.init()
    }
}
