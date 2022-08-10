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
    case myLocation
}

class MainView: BaseView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MainViewAction, Never>()
    
    private(set) var mapView = MTMapView()
    
    private lazy var searchButton: UIButton = {
       let bt = UIButton()
//        bt.setTitle("검색", for: .normal)
        bt.setImage(UIImage(named: "lampSpot_unselected"), for: .normal)
        let length: CGFloat = 60
        bt.layer.cornerRadius = length / 2
        bt.heightAnchor.constraint(equalToConstant: length).isActive = true
        bt.widthAnchor.constraint(equalToConstant: length).isActive = true
        bt.backgroundColor = .darkNavy
        return bt
    }()
    
    private lazy var myTravelButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "myTravel_unselected"), for: .normal)
        let length: CGFloat = 60
        bt.layer.cornerRadius = length / 2
        bt.heightAnchor.constraint(equalToConstant: length).isActive = true
        bt.widthAnchor.constraint(equalToConstant: length).isActive = true
        bt.backgroundColor = .darkNavy
        return bt
    }()
    
    private lazy var myCharacterButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "myCharacter_unselected"), for: .normal)
        let length: CGFloat = 60
        bt.layer.cornerRadius = length / 2
        bt.heightAnchor.constraint(equalToConstant: length).isActive = true
        bt.widthAnchor.constraint(equalToConstant: length).isActive = true
        bt.backgroundColor = .darkNavy
        return bt
    }()
    
    private lazy var myLocationButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "person"), for: .normal)
        let length: CGFloat = 60
        bt.layer.cornerRadius = length / 2
        bt.heightAnchor.constraint(equalToConstant: length).isActive = true
        bt.widthAnchor.constraint(equalToConstant: length).isActive = true
        bt.backgroundColor = .darkNavy
        return bt
    }()
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        searchButton.tapPublisher.sink {[unowned self] _ in
            self.actionSubject.send(.search)
        }
        .store(in: &cancellables)
        
        myTravelButton.tapPublisher.sink { [unowned self] _ in
            self.actionSubject.send(.myTravel)
        }
        .store(in: &cancellables)
        
        myCharacterButton.tapPublisher.sink { [unowned self] _ in
            self.actionSubject.send(.myCharacter)
        }
        .store(in: &cancellables)
        
        myLocationButton.tapPublisher.sink { _ in
            self.actionSubject.send(.myLocation)
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        [mapView, myLocationButton, searchButton, myTravelButton, myCharacterButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            myTravelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            myTravelButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            myCharacterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            myCharacterButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            myLocationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            myLocationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
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
