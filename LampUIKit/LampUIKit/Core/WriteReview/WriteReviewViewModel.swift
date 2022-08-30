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
    case dismiss
    case showMessage(String)
    case numberOfImages(Int)
    
    case startLoading
    case endLoading
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
    private(set) var images: [UIImage] = []
    
    private(set) var location: RecommendedLocation
    
    init(_ location: RecommendedLocation) {
        self.location = location
        super.init()
    }
    
    private var ableCompleteButton: Bool {
        starRating != 0 &&
        comfortRating != nil &&
        atmosphereRating != nil &&
        surroundingRating != nil &&
        foodRating != nil &&
        comments != "" &&
        !images.isEmpty
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
    
    public func addImage( _ image: UIImage) {
        if isAbleToAddMoreImages() {
            images.append(image)
            self.notifySubject.send(.numberOfImages(self.images.count))
            self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
        } else {
            notifySubject.send(.showMessage("사진은 3개로 제한됩니다."))
        }
    }
    
    public func removeImage(at index: Int) {
        images.remove(at: index)
        self.notifySubject.send(.numberOfImages(self.images.count))
        self.notifySubject.send(.ableCompleteButton(ableCompleteButton))
    }
    
    private func isAbleToAddMoreImages() -> Bool {
        return images.count < 3
    }
    
    public func completeButton() {
        postReviews()
    }
    
    private func postReviews() {
        guard
            let atmosphereRating = atmosphereRating,
            let surroundingRating = surroundingRating,
            let foodRating = foodRating
        else { return }
        
        let model = ReviewPostData(
            token: "",
            contentId: location.contentId,
            contentTypeId: location.contentTypeId,
            placeName: location.title,
            starRate: "\(starRating)",
            mood: atmosphereRating,
            surround: surroundingRating,
            foodArea: foodRating,
            content: comments
        )
        
        self.notifySubject.send(.startLoading)
        NetworkService.shared.postReview(model) {[unowned self] result in
            self.notifySubject.send(.endLoading)
            
            switch result {
            case .success(let response):
                print(response)
                if response.isSuccess ?? false {
                    self.postReviewImages()
                    
                } else {
                    self.notifySubject.send(.showMessage(response.message ?? ""))
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func postReviewImages() {
        let imageDatum = images.map({$0.sd_imageData(as: .JPEG, compressionQuality: 0.25)}).compactMap({$0})
        NetworkService.shared.postReviewImages(with: imageDatum, location.contentId) {[unowned self] result in
            switch result {
            case .success(let response):
                print(response)
                if response.isSuccess ?? false {
                    self.notifySubject.send(.dismiss)
                } else {
                    self.notifySubject.send(.showMessage(response.message ?? ""))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
