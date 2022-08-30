//
//  ReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//
import Combine
import Foundation

enum MyReviewsViewmodelNotification {
    case reload
}

class MyReviewsViewModel: BaseViewModel {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<MyReviewsViewmodelNotification, Never>()
    
    private(set) lazy var datum: [UserReviewData] = []
    
    override init() {
        super.init()
        
        NetworkService.shared.fetchMyReviews {[unowned self] result in
            switch result {
            case .success(let response):
                self.datum = response
                self.notifySubject.send(.reload)
                
            case .failure(let error):
                break
            }
        }
    }
}

struct UserReviewData: Codable, Hashable {
    let userId: Int
    let contentId: String
    let reviewIdx: Int
    let date: String
    let contentTypeId: String
    let placeName: String
    let star: String
    let content: String
    let photoUrl: String?
}
