//
//  SearchViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import Combine
import Foundation

enum SearchViewModelNotify {
    case reload
    case startLoading
    case endLoading
}

class SearchViewModel: BaseViewModel {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<SearchViewModelNotify, Never>()
    
    private let service: NetworkService
    
    private(set) var locations = [RecommendedLocation]()
    
    init(_ service: NetworkService = NetworkService.shared) {
        self.service = service
        super.init()
       
    }
    
    public func search(_ text: String) {
        notifySubject.send(.startLoading)
        service.fetchSearchLocations(text) {[unowned self] result in
            switch result {
            case .success(let locationResponse):
                self.locations = locationResponse.result
                self.notifySubject.send(.reload)
                
            case .failure(let error):
                print(error)
            }
            self.notifySubject.send(.endLoading)
        }
    }
    
    public func postAddToMyTrip(at index: Int, _ location: RecommendedLocation) {
        let data = PostAddToMyTripData(
            token: "",
            contentId: location.contentId,
            contentTypeId: location.contentTypeId,
            placeName: location.title,
            placeInfo: "",
            placeAddress: location.addr,
            userMemo: "",
            mapX: location.mapX,
            mapY: location.mapY
        )
        
        locations[index].isOnPlan = true
        
        NetworkService.shared.postAddToMyTravel(data) {[unowned self] result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func deleteFromMyTrip(at index: Int, _ location: RecommendedLocation) {
        guard let planIdx = location.planIdx else { return }
        
        locations[index].isOnPlan = false
        
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
}
