//
//  BaseViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//

import Combine
import Foundation

protocol Notifiable { }

protocol ViewModel { }

class BaseViewModel<T: Notifiable>: NSObject, ViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<T, Never>()
    
    var cancellables: Set<AnyCancellable>
    
    override init() {
        self.cancellables = .init()
    }
    
    public func sendNotification(_ input: T) {
        notifySubject.send(input)
    }
}
