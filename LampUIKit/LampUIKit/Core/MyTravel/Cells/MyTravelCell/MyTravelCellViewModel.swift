//
//  MyTravelCellViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/04.
//
import CoreLocation
import UIKit

enum MyTravelCellViewModelNotifiction: Notifiable {
    case endRefreshing
    case reload
    case showMessage(String)
}

class MyTravelCellViewModel: BaseViewModel<MyTravelCellViewModelNotifiction> {
    private(set) var models: [MyTravelLocation] = []
    private(set) var showDeleteButton: Bool = false
    private(set) var isRefreshing: Bool = false
    private let auth: Autheable
    private let network: Networkable
    init(
        _ auth: Autheable = AuthManager.shared,
        _ network: Networkable = NetworkManager()
    ) {
        self.auth = auth
        self.network = network
        super.init()
    }
    public var toggleShowDeleteButton: Void {
        self.showDeleteButton.toggle()
    }
    public var setIsRefreshing: Bool? {
        didSet {
            self.isRefreshing = setIsRefreshing ?? false
        }
    }
    public func fetchMyTravel() {
        network.get(.fetchMyTravel, [MyTravelLocation].self) {[weak self] result in
            guard let self = self else {return}
            if self.isRefreshing {
                self.sendNotification(.endRefreshing)
                self.isRefreshing = false
            }
            switch result {
            case .success(let locations):
                self.models = locations
                self.sendNotification(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
    public func deleteMyTravel(at index: Int) {
        let targetItem = models[index]
        guard let token = auth.token else { return }
        let data = PostAddToMyTripData(
            token: token,
            contentId: targetItem.contentId,
            contentTypeId: targetItem.contentTypeId,
            image: targetItem.image ?? "",
            placeName: targetItem.placeName,
            placeInfo: targetItem.placeInfo,
            placeAddress: targetItem.placeAddress,
            userMemo: targetItem.userMemo ?? "",
            mapX: targetItem.mapX ?? "",
            mapY: targetItem.mapY ?? ""
        )
        network.post(.postAddToMyTravel, data, Response.self) { [weak self] result in
            switch result {
            case .success:
                self?.models.remove(at: index)
                self?.sendNotification(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
    public func completeTrip(at index: Int) {
        let myTravel = models[index]
        let location = CLLocationManager()
        let coord = location.location?.coordinate
        let lat = "\(coord?.latitude ?? 0)"
        let long = "\(coord?.longitude ?? 0)"
        guard let token = auth.token else {return }
        let param = CompleteTripPostData(token: token, planIdx: myTravel.planIdx, mapX: long, mapY: lat)
        network.post(.postCompleteTrip, param, Response.self) { [weak self] result in
            switch result {
            case .success(let res):
                self?.sendNotification(.showMessage(res.message?.localized ?? ""))
                if res.isSuccess ?? false {
                    self?.models.remove(at: index)
                    self?.sendNotification(.reload)
                }
            case .failure(let error):
                self?.sendNotification(.showMessage(error.localizedDescription))
            }
        }
    }
}
