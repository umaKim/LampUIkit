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
        self.model = MyTravelDataSet(myTravel: [MyTravelLocations(name: "경복궁",
                                                                  category: "",
                                                                  visitableTime: "",
                                                                  address: ""),
                                                MyTravelLocations(name: "경복궁2",
                                                                  category: "",
                                                                  visitableTime: "",
                                                                  address: ""),
                                                MyTravelLocations(name: "경복궁3",
                                                                  category: "",
                                                                  visitableTime: "",
                                                                  address: ""),
                                                MyTravelLocations(name: "경복궁4",
                                                                  category: "",
                                                                  visitableTime: "",
                                                                  address: ""),
                                                MyTravelLocations(name: "경복궁5",
                                                                  category: "",
                                                                  visitableTime: "",
                                                                  address: ""),
                                                MyTravelLocations(name: "경복궁6",
                                                                  category: "",
                                                                  visitableTime: "",
                                                                  address: "")
        ],
                                     favoriteTravel: [MyTravelLocations(name: "경복궁",
                                                                        category: "",
                                                                        visitableTime: "",
                                                                        address: "")],
                                     completedTravel: [MyTravelLocations(name: "경복궁",
                                                                         category: "",
                                                                         visitableTime: "",
                                                                         address: "")])
    }
}

struct MyTravelDataSet: Codable {
    let myTravel: [String]
    let favoriteTravel: [String]
    let completedTravel: [String]
}
