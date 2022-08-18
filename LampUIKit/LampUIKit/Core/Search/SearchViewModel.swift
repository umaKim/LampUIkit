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
    
    public func search(_ text: String) {
        notifySubject.send(.startLoading)
            self.notifySubject.send(.endLoading)
    }
}
