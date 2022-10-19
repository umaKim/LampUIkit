//
//  BaseView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//
import Combine
import UIKit

protocol Actionable { }

protocol ContentViewProtocol {}

class BaseWhiteView: UIView, ContentViewProtocol {
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)

        backgroundColor = .greyshWhite
    }

    var cancellables: Set<AnyCancellable>

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseView<T: Actionable>: UIView, ContentViewProtocol {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<T, Never>()
    
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

