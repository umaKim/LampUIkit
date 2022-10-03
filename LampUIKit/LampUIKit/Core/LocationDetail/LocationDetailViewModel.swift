//
//  LocationDetailViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import Combine
import Foundation

enum LocationDetailViewModelNotification: Notifiable {
    case startLoading
    case endLoading
    
    case sendLocationDetail(LocationDetailData?)
    case locationDetailImages([String])
}

final class LocationDetailViewModel: BaseViewModel<LocationDetailViewModelNotification> {
    private(set) var locationDetail: LocationDetailData?
    private(set) var location: RecommendedLocation?
   
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
            image: myTravelLocation.image,
            contentId: "\(myTravelLocation.contentId)",
            contentTypeId: "\(myTravelLocation.contentTypeId)",
            title: myTravelLocation.placeName,
            addr: myTravelLocation.placeAddress,
            rate: nil,
            bookMarkIdx: "",
            isBookMarked: myTravelLocation.isBookMarked,
            mapX: myTravelLocation.mapX ?? "",
            mapY: myTravelLocation.mapY ?? "",
            planIdx: "\(myTravelLocation.planIdx)",
            travelCompletedDate: nil
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
            planIdx: "\(myBookMarkLocation.placeIdx)",
            travelCompletedDate: nil
        )
    }
    
    convenience init(
        _ myCompletedLocation: MyCompletedTripLocation
    ) {
        self.init()
        
        self.location = .init(image: myCompletedLocation.image,
                              contentId: myCompletedLocation.contentId,
                              contentTypeId: myCompletedLocation.contentTypeId,
                              title: myCompletedLocation.placeName,
                              addr: myCompletedLocation.placeAddress,
                              rate: nil,
                              bookMarkIdx: "",
                              isBookMarked: myCompletedLocation.isBookMarked,
                              mapX: myCompletedLocation.mapX,
                              mapY: myCompletedLocation.mapY,
                              planIdx: myCompletedLocation.planIdx,
                              travelCompletedDate: nil
                              )
    }
    
    public func save() {
        guard let location = location else {return}
        sendNotification(.startLoading)
        NetworkManager.shared.updateBookMark(of: location.contentId, 
                                             contentTypeId: location.contentTypeId,
                                             mapx: location.mapX,
                                             mapY: location.mapY,
                                             placeName: location.title,
                                             placeAddr: location.addr,
                                             completion: {[weak self] result in
            guard let self = self else {return}
            self.sendNotification(.endLoading)
        })
    }
    
    //MARK: - Private
    public func fetchLocationDetail() {
        guard
            let contentId = location?.contentId,
            let contentTypeId = location?.contentTypeId
        else { return }
        sendNotification(.startLoading)
        NetworkManager.shared.fetchLocationDetail(contentId, contentTypeId) {[weak self] result in
            self?.sendNotification(.endLoading)
            guard let self = self else {return }
            switch result {
            case .success(let locationDetail):
                self.locationDetail = locationDetail.result
                self.sendNotification(.sendLocationDetail(self.locationDetail))
            case .failure(let error):
                print(error)
            }
        }
        
        NetworkManager.shared.fetchLocationDetailImage(contentId) {[weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let response):
                let images = response.image
                self.sendNotification(.locationDetailImages(images))
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
        
        if locationDetail?.contentTypeId == "12" || locationDetail?.contentTypeId == "76"  {
            contentInfo = locationDetail?.datailInfo?.usetime ?? ""
        }
        
        if locationDetail?.contentTypeId == "14" || locationDetail?.contentTypeId == "78" {
            contentInfo = locationDetail?.datailInfo?.usetimeculture ?? ""
        }
        
        if locationDetail?.contentTypeId == "15" || locationDetail?.contentTypeId == "85"{
            contentInfo = locationDetail?.datailInfo?.eventstartdate ?? ""
        }
        
        if locationDetail?.contentTypeId == "28" || locationDetail?.contentTypeId == "75"{
            contentInfo = locationDetail?.datailInfo?.usetimeleports ?? ""
        }
        
        if locationDetail?.contentTypeId == "39" || locationDetail?.contentTypeId == "82" {
            contentInfo = locationDetail?.datailInfo?.opentimefood ?? ""
        }

        let data = PostAddToMyTripData(
            token: "",
            contentId: location.contentId,
            contentTypeId: location.contentTypeId,
            image: location.image ?? "",
            placeName: location.title,
            placeInfo: contentInfo,
            placeAddress: location.addr,
            userMemo: "",
            mapX: location.mapX,
            mapY: location.mapY
        )
        
        NetworkManager.shared.postAddToMyTravel(data) {[weak self] result in
            guard let self = self else { return }
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
        NetworkManager.shared.deleteFromMyTravel("\(planIdx)") {[weak self] result  in
            guard let self = self else {return}
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
        postAddToMyTrip()
    }
}
