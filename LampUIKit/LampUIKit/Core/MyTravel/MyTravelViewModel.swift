//
//  MyTravelViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import Combine
import Foundation

enum MyTravelViewModelNotify {
    case reload
}

class MyTravelViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<MyTravelViewModelNotify, Never>()
    
    private(set) var model: MyTravelDataSet
    
    override init() {
        self.model = MyTravelDataSet(myTravel: [],
                                     favoriteTravel: [],
                                     completedTravel: [])
        super.init()
        
        fetchMyTravel()
        fetchSavedTravel()
        fetchCompletedTravel()
    }
    
    private func fetchMyTravel() {
        NetworkService.shared.fetchMyTravel {[unowned self] result in
            switch result {
            case .success(let locations):
                self.model.myTravel = locations
                self.notifySubject.send(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSavedTravel() {
        NetworkService.shared.fetchSavedTravel {[unowned self] result in
            switch result {
            case .success(let locations):
                self.model.favoriteTravel = locations
                self.notifySubject.send(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchCompletedTravel() {
        NetworkService.shared.fetchCompletedTravel {[unowned self] result in
            switch result {
            case .success(let locations):
                self.model.completedTravel = locations
                self.notifySubject.send(.reload)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func deleteMyTravel(at index: Int) {
        let targetItem = model.myTravel[index]
        model.myTravel.remove(at: index)
        NetworkService.shared.removeMyTravel(targetItem)
    }
    
    public func deleteMySaveLocations(at index: Int) {
        let targetItem = model.favoriteTravel[index]
        model.favoriteTravel.remove(at: index)
        NetworkService.shared.updateBookMark(of: "\(targetItem.contentId)",
                                             "\(targetItem.mapX )",
                                             "\(targetItem.mapY )",
                                             "\(targetItem.contentTypeId)",
                                             placeName: "\(targetItem.placeName )",
                                             placeAddr: "\(targetItem.placeAddr )") { result in
            
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

struct MyTravelDataSet: Codable {
    var myTravel: [MyTravelLocation]
    var favoriteTravel: [MyBookMarkLocation]
    var completedTravel: [MyCompletedTripLocation]
}

struct MyTravelLocation: Codable, Hashable {
    let planIdx: Int?
    let travelDate: String?
    let contentId: Int?
    let contentTypeId: Int?
    let placeName: String?
    let placeInfo: String?
    let placeAddress: String?
    let placeAddr: String?
    let userMemo: String?
    let mapX: String?
    let mapY: String?
    let bookMark: Bool?
struct MyBookMarkLocation: Codable, Hashable {
    let placeIdx: Int
    let contentId: Int
    let contentTypeId: Int
    let placeAddr: String
    let placeName: String
    let placeInfo: String?
    let mapX: String
    let mapY: String
    let planIdx: Int?
}
}
