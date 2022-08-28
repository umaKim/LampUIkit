//
//  RecommendedLocationViewmodel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/25.
//
import Combine
import GoogleMaps
import Foundation

enum RecommendedLocationViewmodelNotify {
    case updateAddress(String)
    case reload
}

class RecommendedLocationViewmodel: BaseViewModel {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<RecommendedLocationViewmodelNotify, Never>()
    
    private let geocoder = GMSGeocoder()
    
    private var locationManager = CLLocationManager()
    private(set) var locations: [RecommendedLocation] = []
    
    init(
        _ locatonsSubject: AnyPublisher<[RecommendedLocation], Never>,
        _ locationInfo: CurrentValueSubject<Coord, Never>
    ) {
        super.init()
        
        locatonsSubject
            .sink {[weak self] locations in
                self?.locations = locations
                self?.notifySubject.send(.reload)
            }
            .store(in: &cancellables)
        
        locationInfo
            .debounce(for: 2, scheduler: DispatchQueue.global())
            .sink {[weak self] coord in
            guard let self = self else {return }
            
            self.geocoder.reverseGeocodeCoordinate(.init(latitude: coord.latitude, longitude: coord.longitude)) {[weak self] response, error in
                if let address = response?.firstResult() {
                    let administrativeArea = address.administrativeArea ?? ""
                    let locality = address.locality ?? ""
                    let sublocality = address.subLocality ?? ""
                    
                    let addressString = administrativeArea + " " + locality + " " + sublocality
                    print(addressString)
                    self?.notifySubject.send(.updateAddress(addressString))
                }
            }
        }
        .store(in: &cancellables)
    }
    
    public func save(_ index: Int) {
        locations[index].isBookMarked.toggle()
        let location = locations[index]
        NetworkService.shared.updateBookMark(of: location.contentId,
                                             location.mapX,
                                             location.mapY,
                                             location.contentTypeId,
                                             placeName: location.title,
                                             placeAddr: location.addr,
                                             completion: {[unowned self] result in
            print(result)
        })
    }
    
    public func postAddToMyTrip(at index: Int,_ location: RecommendedLocation) {
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
        
        self.locations[index].isBookMarked = true
        
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
        self.locations[index].isOnPlan = false
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
