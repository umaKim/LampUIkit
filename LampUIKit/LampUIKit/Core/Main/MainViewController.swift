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
        configureFpc(with: nav)
    }
    
    private func setFloatingPanelWithLocationDetailViewController(_ location: RecommendedLocation) {
        let contentVC = LocationDetailViewController(vm: LocationDetailViewModel(location))
        contentVC.delegate = self
        let nav = UINavigationController(rootViewController: contentVC)
        configureFpc(with: nav)
        
        fpc.track(scrollView: contentVC.contentView.contentScrollView)
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
        fpc.move(to: .tip, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.mapView.delegate = self
        
        // 현재 위치 트래킹
        contentView.mapView.currentLocationTrackingMode = .onWithoutHeading
        contentView.mapView.showCurrentLocationMarker = true
        
        bind()
        
        setFloatingPanelWithSearchViewController()
        
        setMapToMyLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchItems()
    }
    
    private lazy var mePt1: MTMapLocationMarkerItem = {
       let pt = MTMapLocationMarkerItem()
        pt.customTrackingImageName = "star_filled"
//        pt.customTrackingImageAnchorPointOffset = MTMapImageOffset(offsetX: 1,offsetY: 1)
        return pt
    }()
    private func bind() {
        contentView
            .actionPublisher
            .sink {[unowned self] action in
                switch action {
                case .search:
                    let vc = SearchViewController(vm: SearchViewModel())
                    vc.delegate = self
                    let nav = UINavigationController(rootViewController: vc)
                    present(nav, animated: true)
                
                case .myTravel:
                    let vc = MyTravelViewController(vm: MyTravelViewModel())
                    vc.delegate = self
                    let nav = UINavigationController(rootViewController: vc)
                    present(nav, animated: true)
                    
                case .myCharacter:
                    let vc = MyCharacterViewController(vm: MyCharacterViewModel())
                    vc.delegate = self
                    let nav = UINavigationController(rootViewController: vc)
                    present(nav, animated: true)
                    
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
                    break
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
        print("didFailWithError")
        print(error)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("didChange")
//        print(mapView.camera)
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
    func searchViewControllerDidTapMapPin() {
        if let sheet = nav?.sheetPresentationController {
            sheet.selectedDetentIdentifier = .medium
        }
        
        setMapToMyLocation()
    }
    
    func searchViewControllerDidTapDismiss() {
        dismiss()
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

class FloatingPanelLampLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 56.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 302.0, edge: .bottom, referenceGuide: .safeArea),
             /* Visible + ToolView */
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 85.0, edge: .bottom, referenceGuide: .safeArea),
        ]
        // + 44.0
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.0
    }
}
