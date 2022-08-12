//
//  MainView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/09.
//

import CombineCocoa
import Combine
import UIKit

enum MainViewAction {
    case search
    case myTravel
    case myCharacter
}

class MainView: BaseView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MainViewAction, Never>()
    
    private(set) var mapView = MTMapView()
    
    private lazy var recommendationButton = EllipseButton(image: UIImage(systemName: "person"))
    private lazy var destinationButton = EllipseButton(image: UIImage(systemName: "house"))
    private lazy var completeButton = EllipseButton(image: UIImage(systemName: "gear"))
    
    private lazy var zoomInButton = SquareButton(UIImage(systemName: "plus"))
    private lazy var zoomOutButton = SquareButton(UIImage(systemName: "minus"))
    
    private lazy var searchButton = CircleButton(UIImage(named: "lampSpot_unselected"), .darkNavy)
    private lazy var myTravelButton = CircleButton(UIImage(named: "myTravel_unselected"), .darkNavy)
    private lazy var myCharacterButton = CircleButton(UIImage(named: "myCharacter_unselected"), .darkNavy)
    private lazy var myLocationButton = CircleButton(UIImage(systemName: "person"), .darkNavy)
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        searchButton
            .tapPublisher
            .sink {[unowned self] _ in
                self.actionSubject.send(.search)
            }
            .store(in: &cancellables)
        
        myTravelButton
            .tapPublisher
            .sink { [unowned self] _ in
                self.actionSubject.send(.myTravel)
            }
            .store(in: &cancellables)
        
        myCharacterButton
            .tapPublisher
            .sink { [unowned self] _ in
                self.actionSubject.send(.myCharacter)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [recommendationButton, destinationButton, completeButton])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 16
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            sv.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            myTravelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            myTravelButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            myCharacterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            myCharacterButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

struct LocationData: Decodable {
    let documents: [KLDocument]
}

struct KLDocument: Decodable {
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let distance: String
    
    enum CodingKeys: String, CodingKey {
        case x, y, distance
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
    }
}
