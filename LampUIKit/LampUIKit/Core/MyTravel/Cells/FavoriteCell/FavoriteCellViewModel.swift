//
//  FavoriteCellViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/04.
//

import UIKit

enum FavoriteCellViewModelNotification: Notifiable {
    case endRefreshing
    case reload
    case showMessage(String)
}

class FavoriteCellViewModel: BaseViewModel<FavoriteCellViewModelNotification> {
    private(set) var models: [MyBookMarkLocation] = []
    private(set) var isRefreshing: Bool = false
    private let network: Networkable
    init(
        _ network: Networkable = NetworkManager()
    ) {
        self.network = network
        super.init()
    }
    public var setIsRefreshing: Bool? {
        didSet{
            self.isRefreshing = setIsRefreshing ?? false
        }
    }
    public func fetchSavedTravel() {
        network.get(.fetchSavedTravel, [MyBookMarkLocation].self) {[weak self] result in
            guard let self = self else { return }
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
    public func deleteMySaveLocations(at index: Int) {
        let targetItem = models[index]
        network.patch(
            .updateBookMark(
                "\(targetItem.contentId)",
                contentTypeId: "\(targetItem.contentTypeId)",
                mapx: "\(targetItem.mapX)",
                mapY: "\(targetItem.mapY)",
                placeName: "\(targetItem.placeName )",
                placeAddr: "\(targetItem.placeAddr )"),
            Response.self,
            parameters: Empty.value
        ) { [weak self] result in
            switch result {
            case .success(_):
                self?.models.remove(at: index)
                self?.sendNotification(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
}
