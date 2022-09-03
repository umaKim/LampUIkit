//
//  ARViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/15.
//

import ARCL
import CoreLocation
import UIKit
import Combine

class ARViewController: UIViewController {
    
    private let contentView = ARView()
    
    private let viewModel: ARViewModel
    
    override func loadView() {
        super.loadView()
        
        self.view = contentView
    }
    
    private var cancellables: Set<AnyCancellable>
    
    init(_ vm: ARViewModel) {
        self.viewModel = vm
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.sceneLocationView.run()
        contentView.sceneLocationView.locationNodeTouchDelegate = self
        
        //        //남산 타워
        ////        37.551236041646284  126.98820799957271
        //        let coordinate = CLLocationCoordinate2D(latitude: 37.551236041646284,
        //                                                longitude: 126.98820799957271 )
        //        let location = CLLocation(coordinate: coordinate, altitude: 300)
        //        let image = UIImage(named: "tower")!.resize(newWidth: 100)
        //
        //        let annotationNode = LocationAnnotationNode(location: location, image: image)
        //
        ////        37.477801520081876, 127.0361977558299
        //        let coordinate2 = CLLocationCoordinate2D(latitude: 37.477801520081876,
        //                                                 longitude: 127.0361977558299)
        //        let location2 = CLLocation(coordinate: coordinate2, altitude: 200)
        //        let image2 = UIImage(named: "house")!.resize(newWidth: 100)
        //
        //        let annotationNode2 = LocationAnnotationNode(location: location2, image: image2)
        //
        //        //37.57592607767667  126.9767190147726
        //        let coordinate3 = CLLocationCoordinate2D(latitude: 37.57592607767667,
        //                                                longitude: 126.9767190147726)
        //        let location3 = CLLocation(coordinate: coordinate3, altitude: 100)
        //        let image3 = UIImage(named: "castle")!.resize(newWidth: 100)
        //
        //        let annotationNode3 = LocationAnnotationNode(location: location3, image: image3)
        //
        //        //파고다 앞
        //        //37.568397755478856,126.98795061048838
        //        let coordinate4 = CLLocationCoordinate2D(latitude: 37.568349,
        //                                                longitude: 126.987844)
        //        let location4 = CLLocation(coordinate: coordinate4, altitude: 50)
        //        let image4 = UIImage(named: "pagoda")!.resize(newWidth: 100)
        //
        //        let annotationNode4 = LocationAnnotationNode(location: location4, image: image4)
        //
        //        //청계천
        //        // 37.568104986089864, 126.98849398168022
        //        let coordinate5 = CLLocationCoordinate2D(latitude: 37.568104986089864,
        //                                                longitude: 126.98849398168022)
        //        let location5 = CLLocation(coordinate: coordinate5, altitude: 50)
        //        let image5 = UIImage(named: "cgRiver")!.resize(newWidth: 100)
        //
        //        let annotationNode5 = LocationAnnotationNode(location: location5, image: image5)
        //
                //test my location ar
                // 37.56786849926285, 경도는 126.98874870039104
        
        guard let lat = Double(viewModel.location.mapY),
              let long = Double(viewModel.location.mapX) else { return }
        let coordinate = CLLocationCoordinate2D(latitude: lat,
                                                longitude: long)
        let location6 = CLLocation(coordinate: coordinate, altitude: 300)
        let loc = viewModel.location
        let customBalloon = CustomBalloonView(title: loc.title, subtitle: loc.addr, imageUrlString: loc.image)
       let annotationNode = LocationAnnotationNode(location: location6, view: customBalloon)
//        annotationNode.ignoreAltitude = true
        
        contentView
            .sceneLocationView
            .addLocationNodesWithConfirmedLocation(locationNodes: [
                annotationNode
            ])
        
        bind()
    }
    
    private func bind() {
        contentView.actionPublisher.sink {[weak self] action in
            guard let self = self else {return }
            switch action {
            case .dismiss:
                self.dismiss(animated: true)
            }
        }
        .store(in: &cancellables)
    }
}

extension ARViewController: LNTouchDelegate {
    func annotationNodeTouched(node: AnnotationNode) {
        
    }
    
    func locationNodeTouched(node: LocationNode) {
        
    }
}
