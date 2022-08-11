//
//  MainViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/09.
//
import CoreLocation
import Alamofire
import Foundation
import Combine

enum MainViewModelNotification {
    case recommendedLocations([RecommendedLocation])
}

class MainViewModel: BaseViewModel  {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<MainViewModelNotification, Never>()
    
    private let network = NetworkService.shared
    
    private let uid: String
    init(_ uid: String) {
        self.uid = uid
        super.init()
        
    }
    
    public func fetchItems() {
        let location = Location(lat: longitude, long: latitude)
        network.fetchRecommendation(location, zoomLevelDistance.getLevel().1) {[unowned self] result in
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.notifySubject.send(.recommendedLocations(items.result))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
    }
}
