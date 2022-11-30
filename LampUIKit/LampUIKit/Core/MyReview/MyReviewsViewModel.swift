//
//  ReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//
import Combine
import Foundation

enum MyReviewsViewmodelNotification: Notifiable {
    case reload
}

class MyReviewsViewModel: BaseViewModel<MyReviewsViewmodelNotification> {
    private(set) lazy var datum: [UserReviewData] = []
    private let network: Networkable
    init(
        _ network: Networkable = NetworkManager()
    ) {
        self.network = network
        super.init()
        fetchMyReviews()
    }
    private func fetchMyReviews() {
        network.get(.fetchMyReviews, [UserReviewData].self) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.datum = response
                self.sendNotification(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
    public func deleteReview(at index: Int) {
        let reviewIdx = datum[index].reviewIdx
        network.delete(.deleteReview(reviewIdx), Response.self) { [weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(_):
                self.datum.remove(at: index)
                self.sendNotification(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
}
