//
//  MainView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/09.
//

import CombineCocoa
import Combine
import UIKit
import GoogleMaps

enum MainViewAction {
    case myLocation
    
    case search
    case myTravel
    case myCharacter
    
    case zoomIn
    case zoomOut
    
    case refresh
}

class MainView: BaseWhiteView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MainViewAction, Never>()
    
//    private(set) var mapView = MTMapView()
    
    private(set) var mapView = GMSMapView()
    
    private lazy var recommendationButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "recommended_selected"), for: .normal)
        return bt
    }()
    
    private lazy var destinationButton: UIButton = {
        let bt = UIButton()
         bt.setImage(UIImage(named: "destination_selected"), for: .normal)
         return bt
     }()
    
    private lazy var completeButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "completed_selected"), for: .normal)
         return bt
     }()
    
    private lazy var zoomInButton = SquareButton(UIImage(systemName: "plus"))
    private lazy var zoomOutButton = SquareButton(UIImage(systemName: "minus"))
    
    private lazy var myLocationButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "myCurrentLocation"), for: .normal)
        return bt
    }()
    
    private lazy var searchButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "Search"), for: .normal)
        return bt
    }()
    private lazy var myTravelButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "myTravel"), for: .normal)
        return bt
    }()
    private lazy var myCharacterButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "myCharacter"), for: .normal)
        return bt
    }()
    
    private lazy var refreshButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .red
        bt.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
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
        
        zoomInButton.tapPublisher.sink { _ in
            self.actionSubject.send(.zoomIn)
        }
        .store(in: &cancellables)
        
        zoomOutButton.tapPublisher.sink { _ in
            self.actionSubject.send(.zoomOut)
        }
        .store(in: &cancellables)
        
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
        
        refreshButton
            .tapPublisher
            .sink { [unowned self] _ in
                self.actionSubject.send(.refresh)
            }
            .store(in: &cancellables)
        
        myLocationButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.myLocation)
            }
            .store(in: &cancellables)
    }
    
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [recommendationButton, destinationButton, completeButton])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 16
        
        let zoomSv = UIStackView(arrangedSubviews: [zoomInButton, zoomOutButton])
        zoomSv.axis = .vertical
        zoomSv.distribution = .fillEqually
        zoomSv.alignment = .fill
        zoomSv.layer.cornerRadius = 20
        zoomSv.clipsToBounds = true
        
        [mapView, sv, zoomSv, searchButton, myTravelButton, myCharacterButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            zoomSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            zoomSv.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            myCharacterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            myCharacterButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            myTravelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            myTravelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            searchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            searchButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
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
