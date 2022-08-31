//
//  MainViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/09.
//
import CoreLocation
import Foundation
import Combine

enum MainViewModelNotification {
    case recommendedLocations([RecommendedLocation])
    case startLoading
    case endLoading
    case moveTo(CLLocationCoordinate2D)
}

struct Coord {
    let latitude: Double
    let longitude: Double
}

enum MapMarkerType {
    case recommended
    case destination
    case completed
}

class MainViewModel: BaseViewModel  {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<MainViewModelNotification, Never>()
    
    private(set) var recommendedPlaces: [RecommendedLocation] = []
    private(set) var markerType: MapMarkerType = .recommended
    
    private(set) var coord: Coord = .init(latitude: 0, longitude: 0)
    
    private let network = NetworkService.shared
    
    private(set) var zoom: Float = 15
    
    private(set) var locationManager = CLLocationManager()
    
    public func appendPlace(_ locaion: RecommendedLocation) {
        self.recommendedPlaces.append(locaion)
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestLocation()
        
        guard let coord = locationManager.location?.coordinate else { return }
        self.setLocation(with: coord.latitude, coord.longitude)
    }
    
    public func zoomIn() {
        if zoom > 20 { return }
        zoom = zoom + 1
    }
    
    public func zoomOut() {
        if 3 > zoom { return }
        zoom = zoom - 1
    }
    
    public func fetchItems() {
        notifySubject.send(.startLoading)
        let location = Location(lat: coord.latitude, long: coord.longitude)
        network.fetchRecommendation(location, zoom.zoomLevel, 20) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.markerType = .recommended
                self.notifySubject.send(.recommendedLocations(items.result))
                
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
            
            self.notifySubject.send(.endLoading)
        }
    }
    
    public func setMyZoomLevel(_ level: Float) {
        zoom = level
    }
    
    public func setMyLocation() {
        guard let coord = locationManager.location?.coordinate else { return }
        self.setLocation(with: coord.latitude, coord.longitude)
        self.notifySubject.send(.moveTo(coord))
    }
    
    public func setLocation(with latitude: Double, _ longitude: Double) {
        self.coord = .init(latitude: latitude, longitude: longitude)
    }
    
    public func fetchAllOver() {
        notifySubject.send(.startLoading)
        network.fetchRecommendationFromAllOver { result in
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.markerType = .recommended
                self.notifySubject.send(.recommendedLocations(items.result))
                
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
            
            self.notifySubject.send(.endLoading)
        }
    }
    
    public func fetchUnvisited() {
        notifySubject.send(.startLoading)
        network.fetchUnvisitedLocations { result in
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
                                        isOnPlan: true)})
                self.markerType = .destination
                self.notifySubject.send(.recommendedLocations(self.recommendedPlaces))
            case .failure(let error):
                print(error)
            }
            self.notifySubject.send(.endLoading)
        }
    }
    
    public func fetchCompleted() {
        notifySubject.send(.startLoading)
        network.fetchCompletedTravel { result in
            switch result {
            case .success(let items):
                self.recommendedPlaces = items
                self.markerType = .completed
                self.notifySubject.send(.recommendedLocations(items))
            case .failure(let error):
                print(error)
            }
            self.notifySubject.send(.endLoading)
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
