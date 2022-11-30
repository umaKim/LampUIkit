//
//  BaseView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//
import Combine
import UIKit

protocol Actionable { }

protocol ContentViewProtocol<T> {
    associatedtype T
    var baseView: UIView { get }
    var actionPublisher: AnyPublisher<T, Never> { get }
    var actionSubject: PassthroughSubject<T, Never> { get }
}

//extension ContentViewProtocol {
//    var actionSubject: PassthroughSubject<T, Never> {
//        PassthroughSubject<T, Never>()
//    }
//
//    func sendAction(_ input: T) {
//        actionSubject.send(input)
//    }
//}

class BaseView<T: Actionable>: UIView, ContentViewProtocol {
    private(set) lazy var baseView: UIView = self
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    internal let actionSubject = PassthroughSubject<T, Never>()
    var cancellables: Set<AnyCancellable>
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        backgroundColor = .greyshWhite
    }
    public func sendAction(_ input: T) {
        actionSubject.send(input)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
