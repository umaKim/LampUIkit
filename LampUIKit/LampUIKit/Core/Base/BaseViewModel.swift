//
//  BaseViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//

import Combine
import Foundation

class BaseViewModel: NSObject {
    override init() {
        self.cancellables = .init()
    }
    
    var cancellables: Set<AnyCancellable>
}
