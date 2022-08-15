//
//  MainViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/09.
//
import CoreLocation
import UIKit

class MainViewController: BaseViewContronller  {

    private let contentView: MainView = MainView()
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.mapView.delegate = self
        
        // 현재 위치 트래킹
        contentView.mapView.currentLocationTrackingMode = .onWithoutHeading
        contentView.mapView.showCurrentLocationMarker = true
        
        bind()
        
        
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
        contentView.mapView.zoomIn(animated: true)
    }
    
    private func zoomOut() {
        contentView.mapView.zoomOut(animated: true)
    }
}

extension MainViewController: MTMapViewDelegate {
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        return false
    }
}

extension MainViewController: SearchViewControllerDelegate {
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
