//
//  ARViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/15.
//

import ARCL
import CoreLocation
import UIKit

class ARViewModel {
    
}

class ARViewController: UIViewController {
    var sceneLocationView = SceneLocationView()
    
    private let viewModel: ARViewModel
    
    init(vm: ARViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    private lazy var dismissButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: ""), for: .normal)
        return bt
    }()
    
    private func setupUI() {
        [dismissButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        sceneLocationView.locationNodeTouchDelegate = self
        
        //남산 타워
//        37.551502,126.988597
        let coordinate = CLLocationCoordinate2D(latitude: 37.551502, longitude: 126.988597)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        let image = UIImage(systemName: "person")!

        let annotationNode = LocationAnnotationNode(location: location, image: image)
        
//        37.477526,127.036416
        let coordinate2 = CLLocationCoordinate2D(latitude: 37.477526, longitude: 127.036416)
        let location2 = CLLocation(coordinate: coordinate2, altitude: 300)
        let image2 = UIImage(systemName: "house")!

        let annotationNode2 = LocationAnnotationNode(location: location2, image: image2)
        
        sceneLocationView.addLocationNodesWithConfirmedLocation(locationNodes: [annotationNode, annotationNode2])
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }
}

extension ARViewController: LNTouchDelegate {
    func annotationNodeTouched(node: AnnotationNode) {
        
    }
    
    func locationNodeTouched(node: LocationNode) {
        
    }
}
    
