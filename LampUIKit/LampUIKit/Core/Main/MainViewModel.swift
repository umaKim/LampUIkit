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
}

class MainViewModel: BaseViewModel  {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<MainViewModelNotification, Never>()
    
    
    private let network = NetworkService.shared
    
    
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
        let location = Location(lat: longitude, long: latitude)
        network.fetchRecommendation(location, zoom.zoomLevel, 20) {[unowned self] result in
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.notifySubject.send(.recommendedLocations(items.result))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func setMyZoomLevel(_ level: Float) {
        zoom = level
    }
    
    public func setMyLocation() {
        guard let coord = locationManager.location?.coordinate else { return }
        self.setLocation(with: coord.latitude, coord.longitude)
        self.notifySubject.send(.myLocation(coord))
    }
    
    public func setLocation(with latitude: Double, _ longitude: Double) {
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
