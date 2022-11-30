//
//  BaseViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//

import Combine
import Foundation

protocol Notifiable { }

protocol ViewModelProtocol {
    associatedtype T
    var notifyPublisher: AnyPublisher<T, Never> { get }
    var notifySubject: PassthroughSubject<T, Never> { get }
    func sendNotification(_ input: T)
}

class BaseViewModel<T: Notifiable>: NSObject, ViewModelProtocol {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    internal let notifySubject = PassthroughSubject<T, Never>()
    var cancellables: Set<AnyCancellable>
    override init() {
        self.cancellables = .init()
    }
    public func sendNotification(_ input: T) {
        notifySubject.send(input)
    }
}
