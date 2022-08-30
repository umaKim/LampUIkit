//
//  LocationDetailViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import Combine
import Foundation

enum LocationDetailViewModelNotify {
    case reload
    case startLoading
    case endLoading
    
    case sendLocationDetail(LocationDetailData?)
    case locationDetailImages([String])
}

final class LocationDetailViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<LocationDetailViewModelNotify, Never>()
    
    private(set) var locationDetail: LocationDetailData?
    private(set) var location: RecommendedLocation?
   
    override init() {
        super.init()
    }
    
    convenience init(_ location: RecommendedLocation) {
        self.init()
        self.location = location
    }
    
    convenience init(
       _ myTravelLocation: MyTravelLocation
    ) {
        self.init()
        
        self.location = .init(
            image: nil,
            contentId: "\(myTravelLocation.contentId)",
            contentTypeId: "\(myTravelLocation.contentTypeId)",
            title: myTravelLocation.placeName,
            addr: myTravelLocation.placeAddress,
            rate: nil,
            bookMarkIdx: "",
            isBookMarked: myTravelLocation.isBookMarked,
            mapX: myTravelLocation.mapX ?? "",
            mapY: myTravelLocation.mapY ?? "",
            planIdx: "\(myTravelLocation.planIdx)"
        )
    }
    
    convenience init(
        _ myBookMarkLocation: MyBookMarkLocation
    ) {
        self.init()
        
        self.location = .init(
            image: nil,
            contentId: "\(myBookMarkLocation.contentId)" ,
            contentTypeId: "\(myBookMarkLocation.contentTypeId)" ,
            title: myBookMarkLocation.placeName,
            addr: myBookMarkLocation.placeAddr,
            rate: nil,
            bookMarkIdx: "",
            isBookMarked: true,
            mapX: myBookMarkLocation.mapX,
            mapY: myBookMarkLocation.mapY,
            planIdx: "\(myBookMarkLocation.placeIdx)"
        )
    }
    
    convenience init(
        _ myCompletedLocation: MyCompletedTripLocation
    ) {
        self.init()
        
    }
    
    public func save() {
        guard let location = location else {
            return
        }
        notifySubject.send(.startLoading)
        NetworkService.shared.updateBookMark(of: location.contentId, 
                                             location.mapX,
                                             location.mapY,
                                             location.contentTypeId,
                                             placeName: location.title,
                                             placeAddr: location.addr,
                                             completion: {[unowned self] result in
            self.notifySubject.send(.endLoading)
        })
    }
    
    //MARK: - Private
    public func fetchLocationDetail() {
        guard
            let contentId = location?.contentId,
            let contentTypeId = location?.contentTypeId
        else { return }
        notifySubject.send(.startLoading)
        NetworkService.shared.fetchLocationDetail(contentId, contentTypeId) {[weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let locationDetail):
                self.locationDetail = locationDetail.result
                self.notifySubject.send(.sendLocationDetail(self.locationDetail))
               
            case .failure(let error):
                print(error)
            }
            
            self.notifySubject.send(.endLoading)
        }
        
        NetworkService.shared.fetchLocationDetailImage(contentId) {[weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let response):
                var images = [String]()
                
//                if let mainImage = self.location?.image {
//                    images.append(mainImage)
//                }

                images.append(contentsOf: response.image)
                self.notifySubject.send(.locationDetailImages(images))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func postAddToMyTrip() {
        guard
            let location = location
        else { return }
        
        var contentInfo: String = ""
        
        if locationDetail?.contentTypeId == "12" {
            contentInfo = locationDetail?.datailInfo?.usetime ?? ""
        }
        
        if locationDetail?.contentTypeId == "14" {
            contentInfo = locationDetail?.datailInfo?.usetimeculture ?? ""
        }
        
        if locationDetail?.contentTypeId == "15" {
            contentInfo = locationDetail?.datailInfo?.eventstartdate ?? ""
        }
        
        if locationDetail?.contentTypeId == "28" {
            contentInfo = locationDetail?.datailInfo?.usetimeleports ?? ""
        }
        
        if locationDetail?.contentTypeId == "39" {
            contentInfo = locationDetail?.datailInfo?.opentimefood ?? ""
        }

        let data = PostAddToMyTripData(
            token: "",
            contentId: location.contentId,
            contentTypeId: location.contentTypeId,
            placeName: location.title,
            placeInfo: contentInfo,
            placeAddress: location.addr,
            userMemo: "",
            mapX: location.mapX,
            mapY: location.mapY
        )
        
        NetworkService.shared.postAddToMyTravel(data) {[unowned self] result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func deleteFromMyTrip() {
        guard let planIdx = locationDetail?.planExist?.planIdx else { return }
        NetworkService.shared.deleteFromMyTravel("\(planIdx)") {[unowned self] result  in
            switch result {
            case .success(let response):
                print(response)
                //MARK: - show alert
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Public
    
    public func addToMyTrip() {
        postAddToMyTrip()
    }
    
    public func removeFromMyTrip() {
        deleteFromMyTrip()
    }
}

struct PostAddToMyTripData: Codable {
    var token: String
    let contentId: String
    let contentTypeId: String
    let placeName: String
    let placeInfo: String
    let placeAddress: String
    let userMemo: String
    let mapX: String
    let mapY: String
}
