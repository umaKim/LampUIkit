//
//  ARViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/29.
//

import Foundation

enum ARViewModelNotification: Notifiable {
    
}

class ARViewModel: BaseViewModel<ARViewModelNotification> {
    
    private(set) var location: RecommendedLocation
    
    init(_ location: RecommendedLocation) {
        self.location = location
        super.init()
        
    }
}
