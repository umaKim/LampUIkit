//
//  LoginView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//

import CombineCocoa
import Combine
import UIKit

class LoginView: UIView {
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
