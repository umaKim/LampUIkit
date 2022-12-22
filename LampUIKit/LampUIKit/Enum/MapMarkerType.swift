//
//  MapMarkerType.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//

import Foundation
import UIKit

enum MapMarkerType {
    case recommended
    case destination
    case completed
}

protocol MapMaker {
    var image: UIImage { get }
}

struct RecommendedMapMarker: MapMaker {
    var image: UIImage {
        return .circleRecommended ?? UIImage()
    }
}

struct DestinationMapMarker: MapMaker {
    var image: UIImage {
        return .circleDestination ?? UIImage()
    }
}

struct CompletedMapMarker: MapMaker {
    var image: UIImage {
        return .circleCompleted ?? UIImage()
    }
}
