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
        
        fpc.addPanel(toParent: self)
        fpc.delegate = self
        
        moveTo(.init(latitude: viewModel.coord.latitude, longitude: viewModel.coord.longitude))
    }
    
    private func moveTo(_ coord: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coord, zoom: viewModel.zoom)
       
        setGMPadding()
        contentView.mapView.animate(to: camera)
    }
    
    private func setGMPadding() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) {
            switch self.fpc.state {
            case .half:
                self.contentView.mapView.padding = .init(top: 140, left: 0, bottom: 302.0, right: 0)
                
            case .tip:
                self.contentView.mapView.padding = .init(top: 100, left: 0, bottom: 85.0, right: 0)
            default:
                break
            }
        } completion: { _ in }
    }
    
    private func dismiss() {
        self.dismiss(animated: true)
    }
    
    private lazy var locationsSubject = PassthroughSubject<[RecommendedLocation], Never>()
    private lazy var locationinfo = CurrentValueSubject<Coord, Never>(viewModel.coord)
}

//MARK: - Configure with FPC
extension MainViewController {
    private func setFloatingPanelWithSearchViewController() {
        let contentVC = SearchViewController(vm: SearchViewModel())
        contentVC.delegate = self
        let nav = UINavigationController(rootViewController: contentVC)
        configureFpc(with: nav, completion: {[weak self] in
            self?.fpc.move(to: .tip, animated: true)
            self?.fpc.track(scrollView: contentVC.contentView.collectionView)
        })
    }
    
    private func setFloatingPanelWithLocationDetailViewController(_ location: RecommendedLocation, isModal: Bool = false) {
        let contentVC = LocationDetailViewController(vm: LocationDetailViewModel(location))
        contentVC.delegate = self
        contentVC.isModal = isModal
        let nav = UINavigationController(rootViewController: contentVC)
        configureFpc(with: nav, completion: {[weak self] in
            self?.fpc.move(to: .full, animated: true)
            self?.fpc.track(scrollView: contentVC.contentView.contentScrollView)
        })
    }
    
    private func setFloatingPanelWithRecommendedLocationViewController() {
        let vm = RecommendedLocationViewmodel(locationsSubject.eraseToAnyPublisher(),
                                              locationinfo)
        let contentVC = RecommendedLocationViewController(vm)
        contentVC.delegate = self
        let nav = UINavigationController(rootViewController: contentVC)
        configureFpc(with: nav) { [weak self] in
            self?.fpc.move(to: .tip, animated: true)
            self?.fpc.track(scrollView: contentVC.contentView.collectionView)
        }
    }
    
    private func configureFpc(with viewController: UIViewController, completion: @escaping () -> Void) {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8.0
        appearance.backgroundColor = .clear
        fpc.surfaceView.appearance = appearance
        
        fpc.surfaceView.grabberHandlePadding = -12.0
        
        let vc = viewController
        fpc.set(contentViewController: vc)
        
        completion()
    }
}

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

//MARK: - Marker
extension MainViewController {
    private func addMarkers(of locations: [RecommendedLocation]) {
        locations.forEach { location in
            addMarker(of: location)
        }
    }
    
    private func addMarker(of location: RecommendedLocation, isSelected: Bool = false) {
        let marker = GMSMarker()
        marker.tracksViewChanges = true
        marker.tracksInfoWindowChanges = false
        marker.appearAnimation = .pop
        let markerView = CustomMarkerView(of: location.image ?? "",
                                          type: viewModel.markerType)
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

//MARK: - Bind
extension MainViewController {
    private func bind() {
        viewModel.locationManager.delegate = self
        contentView.mapView.delegate = self
        
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                HapticManager.shared.feedBack(with: .medium)
                switch action {
                    
                case .zoomIn:
                    self.zoomIn()
                    
                case .zoomOut:
                    self.zoomOut()
                    
                case .refresh:
                    self.viewModel.fetchItems()
                    
                case .myLocation:
                    self.contentView.mapView.animate(toZoom: 15)
                    self.viewModel.setMyZoomLevel(15)
                    self.viewModel.setMyLocation()
                    
                case .allOver:
                    self.contentView.mapView.animate(toZoom: 8)
                    self.viewModel.setMyZoomLevel(8)
                    self.viewModel.fetchAllOver()
                    
                case .unvisited:
                    self.viewModel.fetchUnvisited()
                    
                case .completed:
                    self.viewModel.fetchCompleted()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .recommendedLocations(let locations):
                    self.contentView.mapView.clear()
                    self.addMarkers(of: locations)
                    self.locationsSubject.send(locations)

                case .startLoading:
                    self.showLoadingView()

                case .endLoading:
                    self.dismissLoadingView()
                    
                case .moveTo(let coord):
                    self.moveTo(coord)
                }
            }
            .store(in: &cancellables)
    }
    
    private func navigateMyLocationToTargetLocation(_ location: RecommendedLocation) {
        guard
            let lat = Double(location.mapY),
            let long = Double(location.mapX)
        else { return }
        
        let path = GMSMutablePath()
        path.add(.init(latitude: lat, longitude: long))
        path.add(.init(latitude: viewModel.myLocation.latitude,
                       longitude: viewModel.myLocation.longitude))
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor.red
        polyline.map = contentView.mapView // Your map view
        
        let key: String = "AIzaSyC5lym-6ogUzurxxOfVYIBantJllGGVhDY"
        
        let source = "\(viewModel.myLocation.longitude),\(viewModel.myLocation.latitude)"
        let destination = "\(location.mapY),\(location.mapY)"
        
        let requestUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&key=\(key)"
        print(requestUrl)
        AF.request(requestUrl).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coord =  manager.location?.coordinate else { return }
        let userLocationMarker = GMSMarker(position: coord)
        userLocationMarker.icon = UIImage(named: "userMarker")
        userLocationMarker.map = contentView.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentUmaDefaultAlert(title: error.localizedDescription)
    }
}

//MARK: - GMSMapViewDelegate
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

//MARK: - FloatingPanelControllerDelegate
extension MainViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.state == .tip || fpc.state == .half {
            view.endEditing(true)
        }
        setGMPadding()
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelLampLayout()
    }
}

//MARK: - LocationDetailViewControllerDelegate
extension MainViewController: LocationDetailViewControllerDelegate {
    func locationDetailViewControllerDidTapNavigate(_ location: RecommendedLocation) {
        navigateMyLocationToTargetLocation(location)
    }
    
    func locationDetailViewControllerDidTapBackButton() {
        
    }
    
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

//MARK: - SearchViewControllerDelegate
extension MainViewController: SearchViewControllerDelegate {
    func searchViewControllerDidTapNavigation(at location: RecommendedLocation) {
        navigateMyLocationToTargetLocation(location)
    }
    
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
        fpc.move(to: .half, animated: true)
    }
    
    func searchViewControllerDidTapDismiss() {
        self.view.endEditing(true)
        fpc.move(to: .tip, animated: true)
    }
}

//MARK: - MyTravelViewControllerDelegate
extension MainViewController: MyTravelViewControllerDelegate {
    func myTravelViewControllerDidTapNavigation(_ location: RecommendedLocation) {
        navigateMyLocationToTargetLocation(location)
    }
    
    func myTravelViewControllerDidTapMapButton(_ location: RecommendedLocation) {
        fpc.move(to: .half, animated: true)
        guard
            let lat = Double(location.mapY),
            let long = Double(location.mapX)
        else { return }
        
        self.moveTo(.init(latitude: lat, longitude: long))
    }
    
    func myTravelViewDidTap(_ item: MyTravelLocation) {
        
    }
    
    func myTravelViewControllerDidTapDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - RecommendedLocationViewControllerDelegate
extension MainViewController: RecommendedLocationViewControllerDelegate {
    func recommendedLocationViewControllerDidTapNavigation(location: RecommendedLocation) {
        navigateMyLocationToTargetLocation(location)
    }
    
    func recommendedLocationViewControllerDidTapMyTravel() {
        fpc.move(to: .full, animated: true)
    }
    
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
