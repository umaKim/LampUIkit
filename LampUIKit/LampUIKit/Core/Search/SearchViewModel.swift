//
//  SearchViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//
import AuthManager
import LampNetwork
import Combine
import Foundation

enum SearchViewModelNotification: Notifiable {
    case reload
    case startLoading
    case endLoading
    case showMessage(String)
}

final class SearchViewModel: BaseViewModel<SearchViewModelNotification> {
    private var pageNumber = 1
    private var searchKeyword = ""
    private var isFetching: Bool = false
    private var isPagenationDone: Bool = false
    private let auth: Autheable
    private let network: Networkable
    private(set) var locations = [RecommendedLocation]()
    public var isPaginating: Bool? {
        didSet {
            self.isPagenationDone = !(isPaginating ?? false)
        }
    }
    init(
        _ auth: Autheable = AuthManager.shared,
        _ network: Networkable = NetworkManager()
    ) {
        self.auth = auth
        self.network = network
        super.init()
    }
}

// MARK: - Public methods
extension SearchViewModel {
    public func increasePageNumber() {
        pageNumber += 1
    }
    public func setKeyword(_ text: String) {
        self.searchKeyword = text
        self.initializeAllStates()
    }
    public func fetchSearchKeywordData() {
        self.search(searchKeyword)
    }
    public func searchButtonDidTap() {
        self.locations.removeAll()
        self.search(searchKeyword)
    }
    public func postAddToMyTrip(at index: Int, _ location: RecommendedLocation) {
        guard let token = auth.token else {return }
        let data = PostAddToMyTripData(
            token: token,
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
        network.post(.postAddToMyTravel, data, Response.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.sendNotification(.showMessage(response.message ?? ""))
            case .failure(let error):
                self.sendNotification(.showMessage(error.localizedDescription))
            }
        }
    }
    public func save(_ index: Int) {
        locations[index].isBookMarked.toggle()
        let location = locations[index]
        network.patch(
            .updateBookMark(
                location.contentId,
                contentTypeId: location.contentTypeId,
                mapX: location.mapX,
                mapY: location.mapY,
                placeName: location.title,
                placeAddr: location.addr
            ),
            Response.self,
            parameters: Empty.value
        ) { _ in }
    }
}

// MARK: - Private methods
extension SearchViewModel {
    private func initializeAllStates() {
        self.pageNumber = 1
        self.isFetching = false
        self.isPagenationDone = false
    }
    private func search(_ text: String) {
        guard !isPagenationDone else { return }
        if isFetching == false,
           searchKeyword != "" {
            isFetching = true
            sendNotification(.startLoading)
            network.get(
                .fetchSearchLocations(
                    text,
                    pageSize: 20,
                    pageNumber: pageNumber
                ),
                RecommendedLocationResponse.self
            ) {[weak self] result in
                self?.sendNotification(.endLoading)
                guard let self = self else {return}
                self.isFetching = false
                switch result {
                case .success(let locationResponse):
                    self.isPagenationDone = true
                    self.locations.append(contentsOf: locationResponse.result)
                    self.sendNotification(.reload)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
