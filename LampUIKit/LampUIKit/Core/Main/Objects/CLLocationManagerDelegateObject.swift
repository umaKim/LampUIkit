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

final class CLLocationManagerDelegateObject: NSObject, CLLocationManagerDelegate {
    weak var delegate: CLLocationManagerDelegateObjectProtocol?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        showDefaultAlert(title: error.localizedDescription)
        self.delegate?.showDefaultError(title: error.localizedDescription)
    }
}
