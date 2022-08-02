//
//  ARView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/29.
//

import ARCL
import CoreLocation
import UIKit

final class ARView: BaseView {
    private(set) var sceneLocationView = SceneLocationView()
    
    private let dismissButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        return bt
    }()
    
    init() {
        super.init(frame: .zero)
        
        [sceneLocationView, dismissButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sceneLocationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sceneLocationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sceneLocationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sceneLocationView.topAnchor.constraint(equalTo: topAnchor),
            
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
