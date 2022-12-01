//
//  RecommendedLocationViewmodel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/25.
//
import Combine
import GoogleMaps
import Foundation

enum RecommendedLocationViewmodelNotification: Notifiable {
    case updateAddress(String)
    case showMessage(String)
    case reload
}

class RecommendedLocationViewmodel: BaseViewModel<RecommendedLocationViewmodelNotification> {
    private let geocoder = GMSGeocoder()
    private var locationManager = CLLocationManager()
    private(set) var locations: [RecommendedLocation] = []
    private let auth: Autheable
    private let network: Networkable
    init(
        _ locatonsSubject: AnyPublisher<[RecommendedLocation], Never>,
        _ locationInfo: CurrentValueSubject<Coord, Never>,
        _ auth: Autheable = AuthManager.shared,
        _ network: Networkable = NetworkManager()
    ) {
        self.auth = auth
        self.network = network
        super.init()
        locatonsSubject
            .sink {[weak self] locations in
                self?.locations = locations
                self?.sendNotification(.reload)
            }
            .store(in: &cancellables)
        locationInfo
            .debounce(for: 1, scheduler: DispatchQueue.global())
            .sink {[weak self] coord in
                guard let self = self else { return }
                self.geocoder.reverseGeocodeCoordinate(
                    .init(
                        latitude: coord.latitude,
                        longitude: coord.longitude
                    )
                ) {[weak self] response, _ in
                    if let address = response?.firstResult() {
                        let administrativeArea = address.administrativeArea ?? ""
                        let locality = address.locality ?? ""
                        let sublocality = address.subLocality ?? ""
                        let addressString = administrativeArea + " " + locality + " " + sublocality
                        self?.sendNotification(.updateAddress(addressString))
                    }
                }
            }
            .store(in: &cancellables)
    }
    public func saveLocation(_ index: Int) {
        locations[index].isBookMarked.toggle()
        let location = locations[index]
        network.patch(
            .updateBookMark(
                location.contentId,
                contentTypeId: location.contentTypeId,
                mapX: location.mapX,
                mapY: location.mapY,
                placeName: location.title,
                placeAddr: location.addr),
            Response.self,
            parameters: Empty.value
        ) { _ in }
    }
    public func postAddToMyTrip(at index: Int, _ location: RecommendedLocation) {
        guard let token = auth.token else {return }
        let data = PostAddToMyTripData(
            token: token,
            contentId: location.contentId,
            contentTypeId: location.contentTypeId,
            image: location.image ?? "''",
            placeName: location.title,
            placeInfo: "",
            placeAddress: location.addr,
            userMemo: "",
            mapX: location.mapX,
            mapY: location.mapY
        )
        self.locations[index].isOnPlan = true
        network.post(.postAddToMyTravel, data, Response.self) {[weak self] result in
            switch result {
            case .success(let response):
                self?.sendNotification(.showMessage(response.message ?? ""))
            case .failure(let error):
                self?.sendNotification(.showMessage(error.localizedDescription))
            }
        }
    }
    public func deleteFromMyTrip(at index: Int, _ location: RecommendedLocation) {
        guard let planIdx = location.planIdx else { return }
        self.locations[index].isOnPlan = false
        network.delete(.myTravel("\(planIdx)"), Response.self) { [weak self] result  in
            switch result {
            case .success(let response):
                self?.sendNotification(.showMessage(response.message ?? ""))
            case .failure(let error):
                self?.sendNotification(.showMessage(error.localizedDescription))
            }
        }
    }
}
