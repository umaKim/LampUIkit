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
}

final class LocationDetailViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<LocationDetailViewModelNotify, Never>()
    //MARK: - Private
    
    public func fetchLocationDetail() {
        guard let contentId = location?.contentId else { return }
        notifySubject.send(.startLoading)
        NetworkService.shared.fetchLocationDetail(contentId) { result in
            switch result {
            case .success(let locationDetail):
                self.locationDetail = locationDetail.result
                self.notifySubject.send(.reload)
                
            case .failure(let error):
                print(error)
            }
            
            self.notifySubject.send(.endLoading)
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
        
        NetworkService.shared.postAddToMyTravel(data) { result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    public func addToMyTrip() {
        postAddToMyTrip()
    }
    
    public func removeFromMyTrip() {
        deleteFromMyTrip()
    }
}
