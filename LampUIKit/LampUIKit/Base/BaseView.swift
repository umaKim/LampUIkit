//
//  BaseView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//
import Combine
import UIKit

class BaseWhiteView: UIView {
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

class BaseView: UIView {
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
    }
    
    var cancellables: Set<AnyCancellable>
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
