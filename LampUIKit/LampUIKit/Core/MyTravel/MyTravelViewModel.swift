//
//  MyTravelViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import Foundation

enum MyTravelViewModelNotify {
    case reload
}

class MyTravelViewModel: BaseViewModel {
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
        NetworkService.shared.fetchMyTravel { result in
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
        NetworkService.shared.fetchSavedTravel { result in
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
        NetworkService.shared.fetchCompletedTravel { result in
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
}

struct MyTravelDataSet: Codable {
    let myTravel: [MyTravelLocations]
    let favoriteTravel: [MyTravelLocations]
    let completedTravel: [MyTravelLocations]
}

struct MyTravelLocations: Codable, Hashable {
    let name: String
    let category: String
    let visitableTime: String
    let address: String
    let visitedDate: String?
}
