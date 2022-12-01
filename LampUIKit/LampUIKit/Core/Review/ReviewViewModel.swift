//
//  DetailReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//
import Combine
import Foundation

enum ReviewViewModelNotification: Notifiable {
    case reload
    case message(String)
}

class ReviewViewModel: BaseViewModel<ReviewViewModelNotification> {
    private(set) var location: RecommendedLocation
    private(set) var locationDetail: LocationDetailData
    private(set) var reviews: [ReviewData] = []
    private let auth: Autheable
    private let network: Networkable
    init(
        _ location: RecommendedLocation,
        _ locationDetail: LocationDetailData,
        _ auth: Autheable = AuthManager.shared,
        _ network: Networkable = NetworkManager()
    ) {
        self.location = location
        self.locationDetail = locationDetail
        self.auth = auth
        self.network = network
        super.init()
        fetchReviews()
    }
    private func fetchReviews() {
        network.get(.fetchReviews(location.contentId), [ReviewData].self) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let reviews):
                self.reviews = reviews
                self.sendNotification(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
    public func didTapReport(at index: Int) {
        let idx = "\(reviews[index].reviewIdx ?? 0)"
        guard let token = auth.token else {return }
        let param = LikeDataPatch(token: token, targetReviewId: idx)
        network.post(.postReport, param, Response.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:
                self.sendNotification(.message("성공적으로 신고했습니다"))
            case .failure(let error):
                self.sendNotification(.message(error.localizedDescription))
            }
        }
    }
    public func didTapLike(at index: Int) {
        reviews[index].numLiked = self.reviews[index].numLiked + 1
        guard
            let token = auth.token,
            let idx = reviews[index].reviewIdx
        else {return }
        let param = LikeDataPatch(token: token, targetReviewId: "\(idx)")
        network.patch(.patchLike, Response.self, parameters: param) { _ in }
    }
    public func didTapUnLike(at index: Int) {
        reviews[index].numLiked = self.reviews[index].numLiked - 1
        guard
            let token = auth.token,
            let idx = reviews[index].reviewIdx
        else {return }
        let param = LikeDataPatch(token: token, targetReviewId: "\(idx)")
        network.patch(.patchLike, Response.self, parameters: param) { _ in }
    }
}
