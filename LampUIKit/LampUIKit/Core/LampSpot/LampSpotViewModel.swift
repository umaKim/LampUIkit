//
//  LampSpotViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//
import Foundation
import CoreLocation

class LampSpotViewModel {
    private(set) var models: [String] = ["model1", "model2", "model3"]
    
    init() {
        guard let location = LampLocationManager.shared.location else { return }
        print(location)
    }
}

struct LampSpotResponse: Decodable {
    let recomendingPlaces: [LocationItem]
    let popularPlace: LocationItem
}

class LampLocationManager: NSObject {
    static let shared = LampLocationManager()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
//        requestGPSPermission()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
    
    func requestGPSPermission(){
          switch CLLocationManager.authorizationStatus() {
          case .authorizedAlways, .authorizedWhenInUse:
              print("GPS: 권한 있음")
          case .restricted, .notDetermined:
              print("GPS: 아직 선택하지 않음")
          case .denied:
              print("GPS: 권한 없음")
          default:
              print("GPS: Default")
          }
      }
    
    private(set) var location: Location?
}

extension LampLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude.magnitude
            let longitude = location.coordinate.longitude.magnitude
            
            self.location = .init(mapX: latitude, mapY: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
