//
//  WriteReviewViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import Alamofire
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
    
    private let auth: Autheable
    private let network: Networkable
    
    init(
        _ location: RecommendedLocation,
        _ auth: Autheable = AuthManager.shared,
        _ network: Networkable = NetworkManager()
    ) {
        self.location = location
        self.auth = auth
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
            self.sendNotification(.numberOfImages(images.count))
            self.sendNotification(.ableCompleteButton(ableCompleteButton))
        } else {
            sendNotification(.showMessage("사진은 3개로 제한됩니다."))
        }
    }
    
    public func removeImage(at index: Int) {
        images.remove(at: index)
        sendNotification(.numberOfImages(images.count))
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
            let foodRating = foodRating,
            let token = AuthManager.shared.token
        else { return }
        
        let model = ReviewPostData(
            token: token,
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
        network.post(.postReview, model, Response.self) { [weak self] result in
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
        let imageDatum = images.map({$0.sd_imageData(as: .JPEG, compressionQuality: 0.5)}).compactMap({$0})
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: date)
        
        network.uploadMultipartForm(.postReviewImages(location.contentId, dateString), imageDatum, location.contentId, Response.self) {[weak self] result in
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
