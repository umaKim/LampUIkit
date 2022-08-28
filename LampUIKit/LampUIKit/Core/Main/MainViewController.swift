//
//  MainViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/09.
//
import SDWebImageMapKit
import SDWebImage
import CoreLocation
import UIKit
import FloatingPanel
import GoogleMaps
import Combine

class MainViewController: BaseViewContronller {

    private let contentView: MainView = MainView()
    
    private let viewModel: MainViewModel
    
    private var fpc = FloatingPanelController()
    
    init(_ vm: MainViewModel) {
        self.viewModel = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        styleGoogleMaps()
        
        bind()
        
        setFloatingPanelWithRecommendedLocationViewController()
        
        moveTo(.init(latitude: viewModel.coord.latitude, longitude: viewModel.coord.longitude))
    }
    
    private func moveTo(_ coord: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coord, zoom: viewModel.zoom)
       
        setGMPadding()

        contentView.mapView.animate(to: camera)
    }
    private func setFloatingPanelWithSearchViewController() {
        let contentVC = SearchViewController(vm: SearchViewModel())
        contentVC.delegate = self
        let nav = UINavigationController(rootViewController: contentVC)
        configureFpc(with: nav, completion: {[weak self] in
    }
    
    private func setFloatingPanelWithLocationDetailViewController(_ location: RecommendedLocation) {
        let contentVC = LocationDetailViewController(vm: LocationDetailViewModel(location))
        contentVC.delegate = self
        let nav = UINavigationController(rootViewController: contentVC)
        configureFpc(with: nav, completion: {[weak self] in
    }
    
    private func configureFpc(with viewController: UIViewController) {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8.0
        appearance.backgroundColor = .clear
        fpc.surfaceView.appearance = appearance
        
        fpc.surfaceView.grabberHandlePadding = -12.0
        
        fpc.set(contentViewController: viewController)
        
        fpc.addPanel(toParent: self)
        fpc.delegate = self
//MARK: - Zoom
extension MainViewController {
    private func zoomIn() {
        viewModel.zoomIn()
        contentView.mapView.animate(toZoom: viewModel.zoom)
    }
    
    private func zoomOut() {
        viewModel.zoomOut()
        contentView.mapView.animate(toZoom: viewModel.zoom)
    }
}

extension MainViewController {
    private func addMarkers(of locations: [RecommendedLocation]) {
        locations.forEach { location in
            addMarker(of: location)
        }
    }
    
    private func addMarker(of location: RecommendedLocation, isSelected: Bool = false) {
        let marker = GMSMarker()
        marker.tracksViewChanges = true
        marker.appearAnimation = .pop
        let markerView = CustomMarkerView(of: location.image)
        marker.iconView = markerView
        
        guard
            let lat = Double(location.mapY),
            let long = Double(location.mapX)
        else { return }
        
        marker.position = .init(latitude: lat, longitude: long)
        marker.title = location.title
        marker.map = contentView.mapView
        
        if isSelected {
            contentView.mapView.selectedMarker = marker
        }
        
        marker.tracksInfoWindowChanges = true
    }
}
    private func bind() {
        contentView
            .actionPublisher
            .sink {[unowned self] action in
                switch action {
                case .myTravel:
                    let vc = MyTravelViewController(vm: MyTravelViewModel())
                    vc.delegate = self
                    let nav = UINavigationController(rootViewController: vc)
                    
                case .myCharacter:
                    let vc = MyCharacterViewController(vm: MyCharacterViewModel())
                    vc.delegate = self
                    let nav = UINavigationController(rootViewController: vc)
                    
                case .zoomIn:
                    self.zoomIn()
                    
                case .zoomOut:
                    self.zoomOut()
                    
                case .refresh:
                    self.viewModel.fetchItems()
                    
                case .myLocation:
                    self.viewModel.setMyLocation()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[unowned self] noti in
                switch noti {
                case .recommendedLocations(let locations):
                    self.addMarkers(of: locations)

                case .startLoading:
                    self.showLoadingView()

                case .endLoading:
                    self.dismissLoadingView()
                }
            }
            .store(in: &cancellables)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coord =  manager.location?.coordinate else {return }
        let userLocationMarker = GMSMarker(position: coord)
        userLocationMarker.icon = UIImage(named: "userMarker")
        userLocationMarker.map = contentView.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
extension MainViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let lat = position.target.latitude
        let long = position.target.longitude
        viewModel.setLocation(with: lat, long)
        viewModel.setMyZoomLevel(position.zoom)
        
        locationinfo.send(.init(latitude: lat, longitude: long))
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        HapticManager.shared.feedBack(with: .heavy)
        guard
            let index = viewModel.recommendedPlaces.firstIndex(where: {$0.title == marker.title})
        else { return }

        let location = viewModel.recommendedPlaces[index]
        setFloatingPanelWithLocationDetailViewController(location)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        HapticManager.shared.feedBack(with: .heavy)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard
            let index = viewModel.recommendedPlaces.firstIndex(where: {$0.title == marker.title})
        else { return nil }
        let location = viewModel.recommendedPlaces[index]
        let uv = CustomBalloonView(title: location.title, subtitle: location.addr)
        return uv
    }
}

extension MainViewController: LocationDetailViewControllerDelegate {
    func locationDetailViewControllerDidTapMapButton(_ location: RecommendedLocation) {
        fpc.move(to: .half, animated: true)
        guard
            let lat = Double(location.mapY),
            let long = Double(location.mapX)
        else { return }
        
        self.moveTo(.init(latitude: lat, longitude: long))
    }
    
    func locationDetailViewControllerDidTapDismissButton() {
        fpc.move(to: .tip, animated: true)
        setFloatingPanelWithRecommendedLocationViewController()
        locationsSubject.send(viewModel.recommendedPlaces)
    }
}

extension MainViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.state == .tip {
            view.endEditing(true)
        }
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelLampLayout()
    }
}

extension MainViewController: SearchViewControllerDelegate {
    func searchBarDidTap() {
        fpc.move(to: .full, animated: true)
    }
    
    func searchViewControllerDidTapMapPin(at location: RecommendedLocation) {
        viewModel.appendPlace(location)
        addMarker(of: location, isSelected: true)
        
        guard
            let lat = Double(location.mapY),
            let long = Double(location.mapX)
        else { return }
        
        self.moveTo(.init(latitude: lat, longitude: long))
        
        self.view.endEditing(true)
        fpc.move(to: .tip, animated: true)
    }
    
    func searchViewControllerDidTapDismiss() {
        self.view.endEditing(true)
        fpc.move(to: .tip, animated: true)
    }
}

extension MainViewController: MyTravelViewControllerDelegate {
    func myTravelViewControllerDidTapDismiss() {
        dismiss()
    }
}

extension MainViewController: MyCharacterViewControllerDelegate {
    func myCharacterViewControllerDidTapDismiss() {
        dismiss()
    }
}

extension MainViewController: RecommendedLocationViewControllerDelegate {
    func recommendedLocationViewControllerDidTapSearch() {
        fpc.move(to: .full, animated: true)
    }
    
    func recommendedLocationViewControllerDidTapMyCharacter() {
        fpc.move(to: .full, animated: true)
    }
    
    func recommendedLocationViewControllerDidTapMapPin(location: RecommendedLocation) {
        self.searchViewControllerDidTapMapPin(at: location)
    }
}

//MARK: - Map Styler
extension MainViewController {
    private func styleGoogleMaps() {
        do {
            if let styleUrl = Bundle.main.url(forResource: "style", withExtension: "json") {
                contentView.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleUrl)
                
            } else {
                NSLog("Unable to find style")
            }
        } catch {
            NSLog("Unable to find style")
        }
    }
}
