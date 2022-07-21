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
    
    private var starRating: CGFloat = 0
    private var comfortRating: String = ""
    private var atmosphereRating: String = ""
    private var surroundingRating: String = ""
    private var foodRating: String = ""
    private var comments: String = ""
    
    private var ableCompleteButton: Bool {
        starRating != 0 &&
        comfortRating != "" &&
        atmosphereRating != "" &&
        surroundingRating != "" &&
        foodRating != "" &&
        comments != ""
    }
    
    public func setStarRating(_ rating: CGFloat) {
        self.starRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setComfortRating( _ rating: String) {
        self.comfortRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setAtmosphereRating( _ rating: String) {
        self.atmosphereRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setSurroundingRating( _ rating: String) {
        self.surroundingRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setFoodRating( _ rating: String) {
        self.foodRating = rating
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setComments( _ comments: String) {
        self.comments = comments
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
}
