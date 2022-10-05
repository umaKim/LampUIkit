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

class ARViewController: BaseViewController<ARView, ARViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.sceneLocationView.run()
        contentView.sceneLocationView.locationNodeTouchDelegate = self
        
        guard let lat = Double(viewModel.location.mapY),
              let long = Double(viewModel.location.mapX) else { return }
        let coordinate = CLLocationCoordinate2D(latitude: lat,
                                                longitude: long)
        let location = CLLocation(coordinate: coordinate, altitude: 250)
        let loc = viewModel.location
        let customBalloon = CustomBalloonView(title: loc.title, subtitle: loc.addr, imageUrlString: loc.image)
        let annotationNode = LocationAnnotationNode(location: location, view: customBalloon)
        
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
