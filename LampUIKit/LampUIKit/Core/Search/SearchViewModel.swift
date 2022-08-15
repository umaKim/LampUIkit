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

class SearchViewModel {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<SearchViewModelNotify, Never>()
    
    private let service: KeywordSearchXMLService
    
    private(set) var items = [LocationItem]()
    
    init(_ service: KeywordSearchXMLService = KeywordSearchXMLService.shared) {
        self.cancellables = .init()
        self.service = service
        
        service.$items
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                    break
                    
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {[weak self] items in
                self?.items = items
                self?.notifySubject.send(.reload)
            })
            .store(in: &cancellables)
    }
    
    private var cancellables: Set<AnyCancellable>
    
    public func search(_ text: String) {
        service.fetch(about: text)
        notifySubject.send(.startLoading)
            self.notifySubject.send(.endLoading)
    }
}
