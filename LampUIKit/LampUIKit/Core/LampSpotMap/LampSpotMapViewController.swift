//
//  LampSpotMapViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import Foundation

class LampSpotMapViewController: BaseViewContronller {
    
    private let contentView = LampSpotView()
    
    private let viewModel: LampSpotMapViewModel
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    init(vm: LampSpotMapViewModel) {
        self.viewModel = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
