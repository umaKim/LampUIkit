//
//  WriteReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import Combine
import UIKit

enum WriteReviewViewModelNotify {
    case ableCompleteButton(Bool)
}

class WriteReviewViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<WriteReviewViewModelNotify, Never>()
    
    private var starRating: CGFloat = 2.5
    private var comfortRating: Int?
    private var atmosphereRating: Int?
    private var surroundingRating: Int?
    private var foodRating: Int?
    private var comments: String = ""
    
    private var ableCompleteButton: Bool {
        starRating != 0 &&
        comfortRating != nil &&
        atmosphereRating != nil &&
        surroundingRating != nil &&
        foodRating != nil &&
        comments != ""
    }
    
    public func setStarRating(_ rating: CGFloat) {
        self.starRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setComfortRating( _ rating: Int) {
        self.comfortRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setAtmosphereRating( _ rating: Int) {
        self.atmosphereRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setSurroundingRating( _ rating: Int) {
        self.surroundingRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setFoodRating( _ rating: Int) {
        self.foodRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setComments( _ comments: String) {
        self.comments = comments
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func completeButton() {
        guard
//            let contentId = location.contentId,
            let atmosphereRating = atmosphereRating,
            let surroundingRating = surroundingRating,
            let foodRating = foodRating
        else { return }
        print(location.contentId)
        let model = ReviewPostData(token: "", contentId: location.contentId, starRate: starRating, mood: atmosphereRating, surround: surroundingRating, foodArea: foodRating, content: comments)
        NetworkService.shared.postReview(model) { result in
            switch result {
            case .success(let response):
                print(response)
                print(response.message)
                if response.isSuccess ?? false {
                   
                } else {
                    response.message
                    //TODO: - send message to alert
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
