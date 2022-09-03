//
//  CharacterData.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//
import UIKit
import Foundation

struct CharacterData {
    let characterName: String
    let level: String
    let imageString: String?
    let averageStat: String
    let mileage: String
    let gaugeDatum: [GaugeData]
}

struct GaugeData: Decodable, Hashable {
    let name: String
    let rate: Int
}
