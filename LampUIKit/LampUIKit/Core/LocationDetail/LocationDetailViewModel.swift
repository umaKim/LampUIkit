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
}

final class LocationDetailViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<LocationDetailViewModelNotify, Never>()
        notifySubject.send(.startLoading)
            self.notifySubject.send(.endLoading)
    
    public func addToMyTrip() {
        postAddToMyTrip()
    }
    
    public func removeFromMyTrip() {
        deleteFromMyTrip()
    }
}
