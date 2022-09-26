//
//  ARView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/29.
//

import ARCL
import CoreLocation
import UIKit
import Combine
import CombineCocoa

enum ARViewAction: Actionable {
    case dismiss
}

final class ARView: BaseView<ARViewAction> {
//    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
//    private let actionSubject = PassthroughSubject<ARViewAction, Never>()
    
    private(set) var sceneLocationView = SceneLocationView()
    
    private let dismissButton: UIButton = {
        let bt = UIButton()
        bt.setImage(.xmark, for: .normal)
        return bt
    }()
    
    override init() {
        super.init()
        
        dismissButton
            .tapPublisher
            .sink {[weak self] _ in
//                self?.actionSubject.send(.dismiss)
                self?.sendAction(.dismiss)
            }
            .store(in: &cancellables)
        
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
