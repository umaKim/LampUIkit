//
//  CompletedTravelCellViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/04.
//

import Foundation

enum CompletedTravelCellViewModelNotification: Notifiable {
    case endRefreshing
    case reload
}

class CompletedTravelCellViewModel: BaseViewModel<CompletedTravelCellViewModelNotification> {
    
    private(set) var models: [MyCompletedTripLocation] = []
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
    
    public func fetchCompletedTravel() {
        network.get(.fetchCompletedTravel, [RecommendedLocation].self) {[weak self] result in
            guard let self = self else { return }
            
            if self.isRefreshing {
                self.sendNotification(.endRefreshing)
                self.isRefreshing = false
            }
            
            switch result {
            case .success(let locations):
                self.models = locations.map { location -> MyCompletedTripLocation in
                        .init(planIdx: location.planIdx ?? "",
                              image: location.image ?? "",
                              travelCompletedDate: location.travelCompletedDate ?? "",
                              contentId: location.contentId,
                              contentTypeId: location.contentTypeId,
                              placeInfo: "",
                              placeAddress: location.addr,
                              userMemo: "",
                              mapX: location.mapX,
                              mapY: location.mapY,
                              placeName: location.title,
                              isBookMarked: location.isBookMarked)
                }
                self.sendNotification(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func deleteCompletedTravel(at index: Int) {
        let targetItem = models[index]
        network.delete(.myTravel(targetItem.planIdx), Response.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.models.remove(at: index)
                self?.sendNotification(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
}
