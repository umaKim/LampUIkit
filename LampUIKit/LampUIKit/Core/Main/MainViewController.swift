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
    
    
    private let locationManager = CLLocationManager()
    
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
        
        locationManager.delegate = self
        locationManager.requestLocation()
        
        contentView.mapView.delegate = self
        
        
        // 현재 위치 트래킹
        contentView.mapView.currentLocationTrackingMode = .onWithoutHeading
        contentView.mapView.showCurrentLocationMarker = true
        
        bind()
        
        let pt1 = MTMapPOIItem()
        pt1.itemName = "광화문"
        pt1.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.57592607767667,
                                                          longitude: 126.9767190147726))
       
        pt1.customImage = UIImage(named: "castle")?.resize(newWidth: 50)
        pt1.markerType = .customImage
        
        contentView.mapView.addPOIItems([pt1])
        setMapToMyLocation()
        viewModel.fetchItems()
    }
    
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
                    
                case .myLocation:
                    self.setMapToMyLocation()
                }
            }
            .store(in: &cancellables)
    }
    
    private func dismiss() {
        self.dismiss(animated: true)
    }
}

extension MainViewController: MTMapViewDelegate {
    
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
