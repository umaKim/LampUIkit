//
//  MapView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//
import CombineCocoa
import Combine
import UIKit

enum MapViewAction {
    case back
}

class MapView: BaseView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MapViewAction, Never>()
    
    private(set) lazy var backButton = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)

    private(set) var mapView = MTMapView()
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        backButton.tapPublisher.sink {[unowned self] _ in
            self.actionSubject.send(.back)
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        [mapView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
}

}
