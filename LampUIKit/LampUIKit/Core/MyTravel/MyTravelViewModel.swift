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
    
    override init() {
        super.init()
    }
}

struct MyTravelDataSet: Codable {
    var myTravel: [MyTravelLocation]
    var favoriteTravel: [MyBookMarkLocation]
    var completedTravel: [MyCompletedTripLocation]
}

struct MyTravelLocation: Codable, Hashable {
    let image: String?
    let planIdx: String
    let contentId: String
    let contentTypeId: String
    let placeName: String
    let placeInfo: String
    let placeAddress: String
    let userMemo: String?
    let mapX: String?
    let mapY: String?
    let bookMarkIdx: String
    let isBookMarked: Bool
}

struct MyBookMarkLocation: Codable, Hashable {
    let placeIdx: String
    let contentTypeId: String
    let contentId: String
    let placeAddr: String
    let placeName: String
    let placeInfo: String?
    let mapX: String
    let mapY: String
    let isPlanExist: Bool
    let planIdx: String
}

struct MyCompletedTripLocation: Codable, Hashable {
    let planIdx: String
    let image: String
    let travelCompletedDate: String
    let contentId: String
    let contentTypeId: String
    let placeInfo: String
    let placeAddress: String
    let userMemo: String
    let mapX: String
    let mapY: String
    let placeName: String
    let isBookMarked: Bool
    
}
