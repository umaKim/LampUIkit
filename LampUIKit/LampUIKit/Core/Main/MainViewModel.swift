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
import FloatingPanel

enum MainViewModelNotification: Notifiable {
    case recommendedLocations([RecommendedLocation])
    case startLoading
    case endLoading
    case moveTo(CLLocationCoordinate2D)
    case goBackToBeforeLoginPage
    case setFloatingPanelWithLocationDetailViewController(
        _ location: RecommendedLocation,
        isModal: Bool
    )
    case showDefaultAlert(String)
    case endEditting(_ isTrue: Bool)
    case changeGoogleMapPadding
}

class MainViewModel: BaseViewModel<MainViewModelNotification> {
    private(set) var recommendedPlaces: [RecommendedLocation] = []
    private(set) var markerType: MapMaker = RecommendedMapMarker()
    private(set) var coord: Coord = .init(latitude: 0, longitude: 0)
    private(set) var myLocation: Coord = .init(latitude: 0, longitude: 0)
    private(set) var zoom: Float = 15.0
    private(set) var locationManager = CLLocationManager()
    lazy var locationinfo: CurrentValueSubject<Coord, Never> = CurrentValueSubject<Coord, Never>(self.coord)
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

extension MainViewModel: FloatingPanelControllerDelegateProtocol {
    func endEditing(_ isTrue: Bool) {
        self.notifySubject.send(.endEditting(isTrue))
    }
    func changeGoogleMapPadding() {
        self.notifySubject.send(.changeGoogleMapPadding)
    }
}

extension MainViewModel: CLLocationManagerDelegateObjectProtocol {
    func showDefaultError(title: String) {
        self.notifySubject.send(.showDefaultAlert(title))
    }
}

extension MainViewModel: GMSMapObjectProtocol {
    public func setLocation(with latitude: Double, _ longitude: Double) {
        self.coord = .init(latitude: latitude, longitude: longitude)
    }
    public func setMyZoomLevel(_ level: Float) {
        zoom = level
    }
    func setFloatingPanelWithLocationDetailViewController(_ location: RecommendedLocation, isModal: Bool) {
        notifySubject.send(.setFloatingPanelWithLocationDetailViewController(location, isModal: isModal))
    }
}

// MARK: - Public methods
extension MainViewModel {
    public func zoomIn() {
        if zoom > 20 { return }
        zoom += 1
    }
    public func zoomOut() {
        if 3 > zoom { return }
        zoom -= 1
    }
    public func setMyLocation() {
        guard let coord = locationManager.location?.coordinate else { return }
        self.setLocation(with: coord.latitude, coord.longitude)
        self.sendNotification(.moveTo(coord))
    }
    public func setMyLocation(with latitude: Double, _ longitude: Double) {
        self.myLocation = .init(latitude: latitude, longitude: longitude)
    }
    public func fetchItems() {
        sendNotification(.startLoading)
        let location = Location(lat: coord.latitude, long: coord.longitude)
        network.get(
            .fetchRecommendation(location, zoom.zoomLevel, 20),
            RecommendedLocationResponse.self
        ) {[weak self] result in
            self?.sendNotification(.endLoading)
            guard let self = self else { return }
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.markerType = RecommendedMapMarker()
                self.sendNotification(.recommendedLocations(items.result))
            case .failure(let error):
                print(error)
            }
        }
    }
    public func fetchAllOver() {
        sendNotification(.startLoading)
        network.get(.fetchRecommendationFromAllOver, RecommendedLocationResponse.self) {[weak self] result in
            guard let self = self else { return }
            self.sendNotification(.endLoading)
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.markerType = RecommendedMapMarker()
                self.sendNotification(.recommendedLocations(items.result))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    public func fetchUnvisited() {
        sendNotification(.startLoading)
        network.get(.fetchMyTravel, [MyTravelLocation].self) {[weak self] result in
            guard let self = self else { return }
            self.sendNotification(.endLoading)
            switch result {
            case .success(let locations):
                self.recommendedPlaces = locations.map({
                    RecommendedLocation(
                        image: $0.image,
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
                        isOnPlan: true,
                        travelCompletedDate: nil
                    )
                })
                self.markerType = DestinationMapMarker()
                self.sendNotification(.recommendedLocations(self.recommendedPlaces))
            case .failure(let error):
                print(error)
            }
        }
    }
    public func fetchCompleted() {
        sendNotification(.startLoading)
        network.get(.fetchCompletedTravel, RecommendedLocationResponse.self) {[weak self] result in
            guard let self = self else {return }
            self.sendNotification(.endLoading)
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.markerType = CompletedMapMarker()
                self.sendNotification(.recommendedLocations(items.result))
            case .failure(let error):
                print(error)
            }
        }
    }
    public func fetchPlaces(for category: CategoryType) {
        sendNotification(.startLoading)
        let location = Location(lat: coord.latitude, long: coord.longitude)
        network.patch(
            .fetchCategoryPlaces(location, category),
            RecommendedLocationResponse.self,
            parameters: Empty.value
        ) { [weak self] result in
            guard let self = self else {return}
            self.sendNotification(.endLoading)
            switch result {
            case .success(let items):
                self.recommendedPlaces = items.result
                self.markerType = RecommendedMapMarker()
                self.sendNotification(.recommendedLocations(items.result))
            case .failure(let error):
                print(error)
            }
        }
    }
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            mainFlow()
        case .notDetermined, .denied, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    public func appendPlace(_ locaion: RecommendedLocation) {
        if recommendedPlaces.contains(locaion) { return }
        self.recommendedPlaces.append(locaion)
    }
}

//MARK: - Private methods
extension MainViewModel {
    private func mainFlow() {
        self.locationManager.requestLocation()
        guard let coord = locationManager.location?.coordinate else { return }
        self.setMyLocation(with: coord.latitude, coord.longitude)
        self.setLocation(with: coord.latitude, coord.longitude)
        self.sendNotification(.moveTo(coord))
    }
    private func checkUserIfExist() {
        checkUserAuth { [weak self] in
            guard let self = self else { return }
            self.locationManager.delegate = self
        }
    }
    private func checkUserAuth(completion: @escaping () -> Void) {
        guard let uid = auth.token else {return }
        network.get(.checkUserExist(uid), UserExistCheckResponse.self) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    completion()
                } else {
                    self.kakaoSignout()
                    self.firebaseSignout()
                }
            case .failure:
                self.kakaoSignout()
                self.firebaseSignout()
            }
        }
    }
    private func kakaoSignout() {
        UserApi.shared.logout {[weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
            self.sendNotification(.goBackToBeforeLoginPage)
        }
    }
    private func firebaseSignout() {
        do {
            try Auth.auth().signOut()
            self.sendNotification(.goBackToBeforeLoginPage)
        } catch {
            print(error)
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
