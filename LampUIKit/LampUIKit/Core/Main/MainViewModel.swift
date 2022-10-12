//
//  MainViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/09.
//
import KakaoSDKUser
import FirebaseAuth
import CoreLocation
import Foundation
import Combine

enum MainViewModelNotification: Notifiable {
    case recommendedLocations([RecommendedLocation])
    case startLoading
    case endLoading
    case moveTo(CLLocationCoordinate2D)
    case goBackToBeforeLoginPage
}

class MainViewModel: BaseViewModel<MainViewModelNotification>  {
    
    private(set) var recommendedPlaces: [RecommendedLocation] = []
    private(set) var markerType: MapMarkerType = .recommended
    
    private(set) var coord: Coord = .init(latitude: 0, longitude: 0)
    private(set) var myLocation: Coord = .init(latitude: 0, longitude: 0)
    
    private(set) var zoom: Float = 15.0
    
    private(set) var locationManager = CLLocationManager()
    
    private let auth: Autheable
    private let network: Networkable
    
    init(
        _ auth: Autheable = AuthManager.shared,
        _ network: Networkable = NetworkManager()
    ) {
        self.auth = auth
        self.network = network
        super.init()
        checkUserIfExist()
    }
}
    public func zoomIn() {
        if zoom > 20 { return }
        zoom = zoom + 1
    }
    
    public func zoomOut() {
        if 3 > zoom { return }
        zoom = zoom - 1
    }
    
    public func setMyZoomLevel(_ level: Float) {
        zoom = level
    }
    
    public func setMyLocation() {
        guard let coord = locationManager.location?.coordinate else { return }
        self.setLocation(with: coord.latitude, coord.longitude)
        self.sendNotification(.moveTo(coord))
    }
    
    public func setLocation(with latitude: Double, _ longitude: Double) {
        self.coord = .init(latitude: latitude, longitude: longitude)
    }
    
    public func setMyLocation(with latitude: Double, _ longitude: Double) {
        self.myLocation = .init(latitude: latitude, longitude: longitude)
    }
    
    public func fetchItems() {
        sendNotification(.startLoading)
        let location = Location(lat: coord.latitude, long: coord.longitude)
        network.fetchRecommendation(location, zoom.zoomLevel, 20) {[weak self] result in
            self?.sendNotification(.endLoading)
            guard let self = self else { return }
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.markerType = .recommended
                self.sendNotification(.recommendedLocations(items.result))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func fetchAllOver() {
        sendNotification(.startLoading)
        network.fetchRecommendationFromAllOver {[weak self] result in
            guard let self = self else { return }
            self.sendNotification(.endLoading)
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.markerType = .recommended
                self.sendNotification(.recommendedLocations(items.result))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchUnvisited() {
        sendNotification(.startLoading)
        network.fetchMyTravel {[weak self] result in
            guard let self = self else { return }
            self.sendNotification(.endLoading)
            switch result {
            case .success(let locations):
                self.recommendedPlaces = locations.map({
                    RecommendedLocation(image: $0.image,
                                        contentId: $0.contentId,
                                        contentTypeId: $0.contentTypeId,
                                        title: $0.placeName,
                                        addr: $0.placeAddress,
                                        rate: 0,
                                        bookMarkIdx: $0.bookMarkIdx,
                                        isBookMarked: $0.isBookMarked,
                                        mapX: $0.mapX ?? "",
                                        mapY: $0.mapY ?? "",
                                        planIdx: $0.planIdx,
                                        isOnPlan: true, travelCompletedDate: nil)})
                self.markerType = .destination
                self.sendNotification(.recommendedLocations(self.recommendedPlaces))
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    public func fetchCompleted() {
        sendNotification(.startLoading)
        network.fetchCompletedTravel {[weak self] result in
            guard let self = self else {return }
            self.sendNotification(.endLoading)
            switch result {
            case .success(let items):
                self.recommendedPlaces = items
                self.markerType = .completed
                self.sendNotification(.recommendedLocations(items))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func fetchPlaces(for category: CategoryType) {
        sendNotification(.startLoading)
        let location = Location(lat: coord.latitude, long: coord.longitude)
        network.fetchCategoryPlaces(location, category) {[weak self] result in
            guard let self = self else {return}
            self.sendNotification(.endLoading)
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.markerType = .recommended
                self.sendNotification(.recommendedLocations(items.result))
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
