//
//  InitialSetPageView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//

import UIKit

enum InitialSetPageViewAction: Actionable {
    
}

class InitialSetPageView: BaseView<InitialSetPageViewAction> {

    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
