//
//  LocationDetailViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import Combine
import Foundation

enum LocationDetailViewModelNotify {
    case reload
    case startLoading
    case endLoading
    
    case sendLocationDetail(LocationDetailData?)
    case locationDetailImages([String])
}

final class LocationDetailViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<LocationDetailViewModelNotify, Never>()
    public func save() {
        guard let location = location else {
            return
        }
        notifySubject.send(.startLoading)
        NetworkService.shared.updateBookMark(of: location.contentId, 
                                             location.mapX,
                                             location.mapY,
                                             placeName: location.title,
                                             placeAddr: location.addr,
                                             completion: {[unowned self] result in
            self.notifySubject.send(.endLoading)
        })
    }
    
    //MARK: - Private
    public func fetchLocationDetail() {
        guard
            let contentId = location?.contentId,
            let contentTypeId = location?.contentTypeId
        else { return }
        notifySubject.send(.startLoading)
        NetworkService.shared.fetchLocationDetail(contentId, contentTypeId) {[weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let locationDetail):
                self.locationDetail = locationDetail.result
                self.notifySubject.send(.sendLocationDetail(self.locationDetail))
            case .failure(let error):
                print(error)
            }
            
            self.notifySubject.send(.endLoading)
        }
        
        NetworkService.shared.fetchLocationDetailImage(contentId) {[weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let response):
                var images = [String]()
                
                if let mainImage = self.location?.image {
                    images.append(mainImage)
                }

                images.append(contentsOf: response.image)
                self.notifySubject.send(.locationDetailImages(images))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func postAddToMyTrip() {
        guard
            let location = location
        else { return }

        let data = PostAddToMyTripData(
            token: "",
            contentId: location.contentId,
            contentTypeId: location.contentTypeId,
            contentInfo: location.title,
            contentAddress: location.addr,
            userMemo: "",
            mapX: location.mapX,
            mapY: location.mapY
        )
        
        NetworkService.shared.postAddToMyTravel(data) {[unowned self] result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func deleteFromMyTrip() {
        guard let planIdx = locationDetail?.planExist?.planIdx else { return }
        NetworkService.shared.deleteFromMyTravel("\(planIdx)") {[unowned self] result  in
            switch result {
            case .success(let response):
                print(response)
                //MARK: - show alert
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Public
    
    public func addToMyTrip() {
        postAddToMyTrip()
    }
    
    public func removeFromMyTrip() {
        deleteFromMyTrip()
    }
}
