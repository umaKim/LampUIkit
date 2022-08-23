//
//  DetailReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//

import Foundation

class DetailReviewViewModel: BaseViewModel {
    private(set) var location: RecommendedLocation
    private(set) var locationDetail: LocationDetailData
    private(set) var reviews: [ReviewData] = []
    
    init(
        _ location: RecommendedLocation,
        _ locationDetail: LocationDetailData
    ) {
        self.location = location
        self.locationDetail = locationDetail
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
