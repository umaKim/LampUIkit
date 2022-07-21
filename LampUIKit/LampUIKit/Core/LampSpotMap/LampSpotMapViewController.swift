//
//  LampSpotMapViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import Foundation

class LampSpotMapViewController: BaseViewContronller {
    
    private let contentView = LampSpotView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
}
