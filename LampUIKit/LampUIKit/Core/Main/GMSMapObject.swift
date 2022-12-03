//
//  GMSMapObject.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/12/01.
//

import GoogleMaps
import Combine

protocol GMSMapObjectProtocol: AnyObject {
    var recommendedPlaces: [RecommendedLocation] { get }
    var locationinfo: CurrentValueSubject<Coord, Never> { get }
//    var recommendedLocation: (RecommendedLocation) -> Void { get }
    func setLocation(with latitude: Double, _ longitude: Double)
    func setMyZoomLevel(_ level: Float)
    func setFloatingPanelWithLocationDetailViewController(_ location: RecommendedLocation, isModal: Bool)
}

class GMSMapDelegateObject: NSObject, GMSMapViewDelegate {
    weak var viewModel: GMSMapObjectProtocol?
    init(_ viewModel: GMSMapObjectProtocol) {
        self.viewModel = viewModel
    }
    //Viewmodel을 weak 로 넘겨준다. 그리고 여기에서 GMS에서 해줄수 있는것들을 해준다.
    // 이런식으로 Delegate, datasource 구체화를 해주면 vc가 좀더 홀쭉애 질수 있다.
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let lat = position.target.latitude
        let long = position.target.longitude
        viewModel?.setLocation(with: lat, long)
        viewModel?.setMyZoomLevel(position.zoom)
//        locationinfo.send(.init(latitude: lat, longitude: long))
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        HapticManager.shared.feedBack(with: .heavy)
        guard
            let index = viewModel?.recommendedPlaces.firstIndex(where: {$0.title == marker.title}),
            let location = viewModel?.recommendedPlaces[index]
        else { return }
        viewModel?.setFloatingPanelWithLocationDetailViewController(location, isModal: true)
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        HapticManager.shared.feedBack(with: .medium)
        return false
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard
            let index = viewModel?.recommendedPlaces.firstIndex(where: {$0.title == marker.title}),
            let location = viewModel?.recommendedPlaces[index]
        else { return nil }
        let customBalloonView = CustomBalloonView(title: location.title, subtitle: location.addr)
        return customBalloonView
    }
}

