//
//  MyTravelViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import Foundation

class MyTravelViewModel {
    private(set) var model: MyTravelDataSet
    
    init() {
        self.model = MyTravelDataSet(myTravel: ["good", "good","good","good","good","good"],
                                     favoriteTravel: ["awesome","good","good","good","good","good"],
                                     completedTravel: ["god","good","good","good","good","good","good"])
    }
}

struct MyTravelDataSet: Codable {
    let myTravel: [String]
    let favoriteTravel: [String]
    let completedTravel: [String]
}
