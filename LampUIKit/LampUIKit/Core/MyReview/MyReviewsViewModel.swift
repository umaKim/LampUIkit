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
        
        NetworkService.shared.fetchMyReviews {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.datum = response
                self.notifySubject.send(.reload)
                
            case .failure(let error):
                break
            }
        }
    }
    
    public func deleteReview(at index: Int) {
        NetworkService.shared.deleteReview(datum[index].reviewIdx) { result in
            switch result {
            case .success(let response):
                self.datum.remove(at: index)
                self.notifySubject.send(.reload)
                
            case .failure(let error):
                print(error)
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
    let photoUrl: [String]
}
