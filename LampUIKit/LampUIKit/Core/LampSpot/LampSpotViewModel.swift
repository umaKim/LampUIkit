//
//  LampSpotViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//
import UIKit
import Foundation

class LampSpotViewModel {
    private(set) var models: [String] = ["model1", "model2", "model3"]
}

struct LampSpotResponse: Decodable {
    let recomendingPlaces: [LocationItem]
    let popularPlace: LocationItem
}
