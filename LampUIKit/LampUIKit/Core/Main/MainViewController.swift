//
//  MainViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/09.
//
import CoreLocation
import UIKit
import FloatingPanel
import GoogleMaps

class MainViewController: BaseViewContronller  {

    private let contentView: MainView = MainView()
    
    private var fpc = FloatingPanelController()
    
    init(_ vm: MainViewModel) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        
        view = contentView
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bind()
        
        setFloatingPanelWithSearchViewController()
        
        setMapToMyLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchItems()
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
    
    private func dismiss() {
        self.dismiss(animated: true)
    }
    private func zoomIn() {
        viewModel.zoomIn()
        contentView.mapView.animate(toZoom: viewModel.zoom)
    }
    
    private func zoomOut() {
        viewModel.zoomOut()
        contentView.mapView.animate(toZoom: viewModel.zoom)
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
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    }
}
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
        
    }
    
    func searchViewControllerDidTapDismiss() {
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

    }

    }
}
