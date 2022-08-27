//
//  ARViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/15.
//

import ARCL
import CoreLocation
import UIKit

class ARViewController: UIViewController {
    
    private let contentView = ARView()
    
    private let viewModel: ARViewModel
    
    override func loadView() {
        super.loadView()
        
        self.view = contentView
    }
    
    init(vm: ARViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.sceneLocationView.run()
        contentView.sceneLocationView.locationNodeTouchDelegate = self
        
        //남산 타워
//        37.551170, 126.988290
        let coordinate = CLLocationCoordinate2D(latitude: 37.551170, longitude: 126.988290)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        let image = UIImage(named: "tower")!.resize(newWidth: 100)

        let annotationNode = LocationAnnotationNode(location: location, image: image)
        
//        37.477526,127.036416
        let coordinate2 = CLLocationCoordinate2D(latitude: 37.477526, longitude: 127.036416)
        let location2 = CLLocation(coordinate: coordinate2, altitude: 300)
        let image2 = UIImage(named: "house")!.resize(newWidth: 100)

        let annotationNode2 = LocationAnnotationNode(location: location2, image: image2)
        
        contentView
            .sceneLocationView
            .addLocationNodesWithConfirmedLocation(locationNodes: [annotationNode, annotationNode2])
    private func bind() {
        contentView.actionPublisher.sink {[weak self] action in
            guard let self = self else {return }
            switch action {
            case .dismiss:
                self.dismiss(animated: true)
                
            case .add:
                //ADD object
                // on Screen
                break
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
