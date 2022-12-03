//
//  CLLocationManagerDelegateObject.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/12/01.
//
import UIKit
import MapKit

protocol CLLocationManagerDelegateObjectProtocol: AnyObject {
    func showDefaultError(title: String)
}

class CLLocationManagerDelegateObject: NSObject, CLLocationManagerDelegate {
    weak var viewModel: CLLocationManagerDelegateObjectProtocol?
    init(_ viewModel: CLLocationManagerDelegateObjectProtocol) {
        self.viewModel = viewModel
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        showDefaultAlert(title: error.localizedDescription)
        self.viewModel?.showDefaultError(title: error.localizedDescription)
    }
}
