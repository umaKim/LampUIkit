//
//  MyTravelViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import Foundation

enum MyTravelViewModelNotify {
    case reload
}
    private(set) var model: MyTravelDataSet
    
    init() {
        self.model = MyTravelDataSet(myTravel:
                                        [
                                            MyTravelLocations(name: "경복궁",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁2",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁3",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁4",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁5",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁6",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: "")
                                        ],
                                     favoriteTravel:
                                        [
                                            MyTravelLocations(name: "경복궁",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁2",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁3",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁4",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁5",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                            MyTravelLocations(name: "경복궁6",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "", visitedDate: ""),
                                        ],
                                     completedTravel:
                                        [
                                            MyTravelLocations(name: "경복궁1",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "",
                                                              visitedDate: "2022년 6월 30일"),
                                            MyTravelLocations(name: "경복궁2",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "",
                                                              visitedDate: "2022년 6월 30일"),
                                            MyTravelLocations(name: "경복궁3",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "",
                                                              visitedDate: "2022년 6월 30일"),
                                            MyTravelLocations(name: "경복궁4",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "",
                                                              visitedDate: "2022년 6월 30일"),
                                            MyTravelLocations(name: "경복궁5",
                                                              category: "",
                                                              visitableTime: "",
                                                              address: "",
                                                              visitedDate: "2022년 6월 30일")
                                        ]
        )
    }
}

struct MyTravelDataSet: Codable {
    let myTravel: [MyTravelLocations]
    let favoriteTravel: [MyTravelLocations]
    let completedTravel: [MyTravelLocations]
}

struct MyTravelLocations: Codable, Hashable {
    let name: String
    let category: String
    let visitableTime: String
    let address: String
    let visitedDate: String?
}
