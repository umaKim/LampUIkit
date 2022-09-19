//
//  SearchViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import Combine
import Foundation

enum SearchViewModelNotify {
    case reload
    case startLoading
    case endLoading
    case showMessage(String)
}

class SearchViewModel: BaseViewModel {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<SearchViewModelNotify, Never>()
    
    private let service: NetworkService
    
    private(set) var locations = [RecommendedLocation]()
    
    init(_ service: NetworkService = NetworkService.shared) {
        self.service = service
        super.init()
    }
    
    private var pageNumber = 1
    
    public func increasePageNumber() {
        pageNumber += 1
    }
    
    public func setKeyword(_ text: String) {
        self.searchKeyword = text
        self.initializeAllStates()
    }
    
    private func initializeAllStates() {
        self.pageNumber = 1
        self.isFetching = false
        self.isPagenationDone = false
    }
    
    public func fetchSearchKeywordData() {
        self.search(searchKeyword)
    }
    
    public func searchButtonDidTap() {
        self.locations.removeAll()
        self.search(searchKeyword)
    }
    
    private var searchKeyword = ""
    
    private var isFetching: Bool = false
    private var isPagenationDone: Bool = false
    
    public func search(_ text: String) {
        guard !isPagenationDone else { return }
        
        if isFetching == false {
            isFetching = true
            notifySubject.send(.startLoading)
            service.fetchSearchLocations(text, pageNumber: pageNumber) {[weak self] result in
                guard let self = self else {return}
                self.isFetching = false
                switch result {
                case .success(let locationResponse):
                    if locationResponse.result.isEmpty {
                        self.isPagenationDone = true
                    } else {
                        self.increasePageNumber()
                    }
                    self.locations.append(contentsOf: locationResponse.result)
                    self.notifySubject.send(.reload)
                    
                case .failure(let error):
                    print(error)
                }
                self.notifySubject.send(.endLoading)
            }
        }
    }
    
    public func postAddToMyTrip(at index: Int, _ location: RecommendedLocation) {
        let data = PostAddToMyTripData(
            token: "",
            contentId: location.contentId,
            contentTypeId: location.contentTypeId,
            image: location.image ?? "",
            placeName: location.title,
            placeInfo: "",
            placeAddress: location.addr,
            userMemo: "",
            mapX: location.mapX,
            mapY: location.mapY
        )
        
        locations[index].isOnPlan = true
        
        NetworkService.shared.postAddToMyTravel(data) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                print(response)
                self.notifySubject.send(.showMessage(response.message ?? ""))
                
            case .failure(let error):
                print(error)
                self.notifySubject.send(.showMessage(error.localizedDescription))
            }
        }
    }
    
    public func deleteFromMyTrip(at index: Int, _ location: RecommendedLocation) {
        guard let planIdx = location.planIdx else { return }
        
        locations[index].isOnPlan = false
        
        NetworkService.shared.deleteFromMyTravel("\(planIdx)") {[weak self] result  in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                print(response)
                self.notifySubject.send(.showMessage(response.message ?? ""))

            case .failure(let error):
                print(error)
                self.notifySubject.send(.showMessage(error.localizedDescription))
            }
        }
    }
    
    
    public func save(_ index: Int) {
        locations[index].isBookMarked.toggle()
        let location = locations[index]
        NetworkService.shared.updateBookMark(of: location.contentId,
                                             contentTypeId: location.contentTypeId,
                                             mapx: location.mapX,
                                             mapY: location.mapY,
                                             placeName: location.title,
                                             placeAddr: location.addr,
                                             completion: {[weak self] result in
            guard let self = self else {return}
            print(result)
        })
    }
}
