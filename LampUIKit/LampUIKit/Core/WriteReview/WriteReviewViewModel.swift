//
//  WriteReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import Combine
import UIKit

enum WriteReviewViewModelNotification: Notifiable {
    case ableCompleteButton(Bool)
    case dismiss
    case showMessage(String)
    case numberOfImages(Int)
    
    case startLoading
    case endLoading
}

class WriteReviewViewModel: BaseViewModel<WriteReviewViewModelNotification> {
    
    private var starRating: CGFloat = 0
    private var comfortRating: Int?
    private var atmosphereRating: Int?
    private var surroundingRating: Int?
    private var foodRating: Int?
    private var comments: String = ""
    private(set) var images: [UIImage] = []
    
    private(set) var location: RecommendedLocation
    
    private let network: Networkable
    
    init(
        _ location: RecommendedLocation,
        _ network: NetworkManager = NetworkManager.shared
    ) {
        self.location = location
        self.network = network
        super.init()
    }
    
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
        self.sendNotification(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setComfortRating( _ rating: Int) {
        self.comfortRating = rating + 1
        self.sendNotification(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setAtmosphereRating( _ rating: Int) {
        self.atmosphereRating = rating + 1
        self.sendNotification(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setSurroundingRating( _ rating: Int) {
        self.surroundingRating = rating + 1
        self.sendNotification(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setFoodRating( _ rating: Int) {
        self.foodRating = rating + 1
        self.sendNotification(.ableCompleteButton(ableCompleteButton))
    }
    
    public func setComments( _ comments: String) {
        self.comments = comments
        self.sendNotification(.ableCompleteButton(ableCompleteButton))
    }
    
    public func addImage( _ image: UIImage) {
        if isAbleToAddMoreImages() {
            images.append(image)
            self.sendNotification(.numberOfImages(self.images.count))
            self.sendNotification(.ableCompleteButton(ableCompleteButton))
        } else {
            sendNotification(.showMessage("사진은 3개로 제한됩니다."))
        }
    }
    
    public func removeImage(at index: Int) {
        images.remove(at: index)
        sendNotification(.numberOfImages(self.images.count))
        sendNotification(.ableCompleteButton(ableCompleteButton))
    }
    
    private func isAbleToAddMoreImages() -> Bool {
        return images.count < 3
    }
    
    public func completeButton() {
        postReviews()
    }
    
    private func postReviews() {
        guard
            let comfortRating = comfortRating,
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
            satisfaction: comfortRating,
            mood: atmosphereRating,
            surround: surroundingRating,
            foodArea: foodRating,
            content: comments
        )
        
        self.sendNotification(.startLoading)
        NetworkManager.shared.postReview(model) {[weak self] result in
            guard let self = self else {return}
            self.sendNotification(.endLoading)
            
            switch result {
            case .success(let response):
                if response.isSuccess ?? false {
                    if !self.images.isEmpty {
                        self.postReviewImages()
                    } else {
                        self.sendNotification(.dismiss)
                    }
                    
                } else {
                    self.sendNotification(.showMessage(response.message ?? ""))
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func postReviewImages() {
        let imageDatum = images.map({$0.sd_imageData(as: .JPEG, compressionQuality: 0.25)}).compactMap({$0})
        NetworkManager.shared.postReviewImages(with: imageDatum, location.contentId) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess ?? false {
                    self.sendNotification(.dismiss)
                } else {
                    self.sendNotification(.showMessage(response.message ?? ""))
                }
            case .failure(let error):
                self.sendNotification(.showMessage(error.localizedDescription))
            }
        }
    }
}
