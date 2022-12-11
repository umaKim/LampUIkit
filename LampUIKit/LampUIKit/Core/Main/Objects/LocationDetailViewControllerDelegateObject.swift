//
//  LocationDetailViewControllerDelegateObject.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/12/01.
//

import Foundation

protocol LocationDetailViewControllerDelegateProtocol: AnyObject { }

final class LocationDetailViewControllerDelegateObject: NSObject, LocationDetailViewControllerDelegate {
    weak var delegate: LocationDetailViewControllerDelegateProtocol?
    func locationDetailViewControllerDidTapDismissButton() { }
    func locationDetailViewControllerDidTapBackButton() { }
    func locationDetailViewControllerDidTapMapButton(_ location: RecommendedLocation) { }
    func locationDetailViewControllerDidTapNavigate(_ location: RecommendedLocation) { }
}
