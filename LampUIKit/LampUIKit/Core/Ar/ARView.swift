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

enum ARViewAction {
    case dismiss
    case add
}

final class ARView: BaseView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ARViewAction, Never>()
    
    private(set) var sceneLocationView = SceneLocationView()
    
    private let dismissButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        return bt
    }()
    
    private let addButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("Add", for: .normal)
        return bt
    }()
    
    override init() {
        super.init()
        
        addButton.tapPublisher.sink { _ in
            self.actionSubject.send(.add)
        }
        .store(in: &cancellables)
        
        dismissButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.dismiss)
            }
            .store(in: &cancellables)
        
        [sceneLocationView, addButton, dismissButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sceneLocationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sceneLocationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sceneLocationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sceneLocationView.topAnchor.constraint(equalTo: topAnchor),
            
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 26),
            
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
