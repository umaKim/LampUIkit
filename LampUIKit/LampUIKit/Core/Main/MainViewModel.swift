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
    
    private(set) var latitude: Double = 0
    private(set) var longitude: Double = 0
    
    private let network = NetworkService.shared
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestLocation()
        
        guard let coord = locationManager.location?.coordinate else { return }
        self.setLocation(with: coord.latitude, coord.longitude)
    
    private func setLocation(with latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
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

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError")
        print(error)
    }
}
