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

enum MainViewAction: Actionable {
    case allOver
    case unvisited
    case completed
    
    case history
    case nature
    case art
    case activity
    case food
    
    case myLocation
    
    case zoomIn
    case zoomOut
    
    case refresh
}

class MainView: BaseView<MainViewAction> {
    
    private(set) var mapView = GMSMapView()
    
    private lazy var allOverButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "recommended_selected".localized), for: .normal)
        return bt
    }()
    
    private lazy var destinationButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "destination_selected".localized), for: .normal)
        return bt
    }()
    
    private lazy var completeButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "completed_selected".localized), for: .normal)
        return bt
    }()
    
    private lazy var historyButton: UIButton = {
        let bt = UIButton()
         bt.setImage(.init(named: "filterHistory".localized), for: .normal)
         return bt
    }()
    
    private lazy var cultureButton: UIButton = {
       let bt = UIButton()
        bt.setImage(.init(named: "filterCulture".localized), for: .normal)
        return bt
    }()
    
    private lazy var cusineButton: UIButton = {
       let bt = UIButton()
        bt.setImage(.init(named: "filterCusine".localized), for: .normal)
        return bt
    }()
    
    private lazy var sportsButton: UIButton = {
       let bt = UIButton()
        bt.setImage(.init(named: "filterSports".localized), for: .normal)
        return bt
    }()
    
    private lazy var forestButton: UIButton = {
       let bt = UIButton()
        bt.setImage(.init(named: "filterForest".localized), for: .normal)
        return bt
    }()
    
    lazy var buttonsView: HorizontalScrollView = {
        let view = HorizontalScrollView()
        return view
    }()
    
    private lazy var zoomInButton = SquareButton(UIImage(systemName: "plus")?.withTintColor(.darkNavy, renderingMode: .alwaysOriginal))
    private lazy var zoomOutButton = SquareButton(UIImage(systemName: "minus")?.withTintColor(.darkNavy, renderingMode: .alwaysOriginal))
    
    private lazy var myLocationButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "myLocation"), for: .normal)
        return bt
    }()
    
    private lazy var refreshButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "refresh"), for: .normal)
        return bt
    }()
    
    override init() {
        super.init()
        
        mapView.isMyLocationEnabled = true
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        allOverButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.allOver)
            }
            .store(in: &cancellables)
        
        destinationButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.unvisited)
            }
            .store(in: &cancellables)
        
        completeButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.completed)
            }
            .store(in: &cancellables)
        
        historyButton.tapPublisher.sink { [weak self] _ in
            guard let self = self else {return }
            self.sendAction(.history)
        }
        .store(in: &cancellables)
        
        cultureButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return }
            self.sendAction(.art)
        }
        .store(in: &cancellables)
        
        cusineButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return }
            self.sendAction(.food)
        }
        .store(in: &cancellables)
        
        sportsButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return }
            self.sendAction(.activity)
        }
        .store(in: &cancellables)
        
        forestButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return }
            self.sendAction(.nature)
        }
        .store(in: &cancellables)
        
        zoomInButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.zoomIn)
            }
            .store(in: &cancellables)
        
        zoomOutButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.zoomOut)
            }
            .store(in: &cancellables)
        
        refreshButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.sendAction(.refresh)
            }
            .store(in: &cancellables)
        
        myLocationButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.myLocation)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        buttonsView.model = [allOverButton, destinationButton, completeButton, historyButton, cultureButton, cusineButton, sportsButton, forestButton]
        
        let zoomSv = UIStackView(arrangedSubviews: [zoomInButton, zoomOutButton])
        zoomSv.axis = .vertical
        zoomSv.distribution = .fillEqually
        zoomSv.alignment = .fill
        zoomSv.layer.cornerRadius = 20
        zoomSv.clipsToBounds = true
        
        [mapView, buttonsView, refreshButton, myLocationButton, zoomSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            buttonsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 50),
            
            refreshButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            refreshButton.bottomAnchor.constraint(equalTo: myLocationButton.topAnchor, constant: -16),
            
            myLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            myLocationButton.bottomAnchor.constraint(equalTo: zoomSv.topAnchor, constant:  -16),
            
            zoomSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            zoomSv.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
