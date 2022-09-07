//
//  DetailReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//
import Combine
import Foundation

enum ReviewViewModelNotify {
    case reload
    case message(String)
}

class ReviewViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<ReviewViewModelNotify, Never>()
    
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
        
        fetchReviews()
    }
    
    private func fetchReviews() {
        NetworkService.shared.fetchReviews(location.contentId) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let reviews):
                self.reviews = reviews
                self.notifySubject.send(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func didTapReport(at index: Int) {
        let idx = "\(reviews[index].reviewIdx ?? 0)"
        NetworkService.shared.postReport(idx) { result in
            switch result {
            case .success(let response):
                self.notifySubject.send(.message("성공적으로 신고했습니다."))
                
            case .failure(let error):
                self.notifySubject.send(.message(error.localizedDescription))
            }
        }
    }
    
    public func didTapLike(at index: Int) {
        reviews[index].numLiked = self.reviews[index].numLiked + 1
        let idx = "\(reviews[index].reviewIdx ?? 0)"
        print("didTapLike \(reviews[index].numLiked)")
        NetworkService.shared.patchLike(idx)
    }
    
    public func didTapUnLike(at index: Int) {
        reviews[index].numLiked = self.reviews[index].numLiked - 1
        let idx = "\(reviews[index].reviewIdx ?? 0)"
        NetworkService.shared.patchLike(idx)
    }
}
