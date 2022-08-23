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
    
    private func fetchReviews() {
        NetworkService.shared.fetchReviews(location.contentId) { result in
            switch result {
            case .success(let reviews):
                self.reviews = reviews
                self.notifySubject.send(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
}
