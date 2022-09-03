//
//  RecommendedLocationView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/25.
//
import Combine
import CombineCocoa
import UIKit

enum RecommendedLocationViewAction {
    case search
    case myCharacter
    case myTravel
}

class RecommendedLocationView: BaseWhiteView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<RecommendedLocationViewAction, Never>()
    
    private(set) lazy var customNavigationbar = CustomNavigationBarView()
    
    private(set) var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        cl.minimumLineSpacing = 18
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(SearchRecommendationCollectionViewCell.self, forCellWithReuseIdentifier: SearchRecommendationCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        cv.keyboardDismissMode = .onDrag
        cv.contentInset = .init(top: 16, left: 0, bottom: 80, right: 0)
        return cv
    }()
    
    private(set) lazy var searchButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "Search"), for: .normal)
        return bt
    }()
    
    private(set) lazy var travelButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "myTravel"), for: .normal)
        return bt
    }()
    
    private(set) lazy var myCharacter: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "myCharacter"), for: .normal)
        return bt
    }()
    
    public func updateCustomNavigationBarTitle(_ text: String) {
        customNavigationbar.updateTitle(text)
    }
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    private func bind() {
        searchButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.search)
            }
            .store(in: &cancellables)
        
        travelButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.myTravel)
            }
            .store(in: &cancellables)
        
        myCharacter
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.myCharacter)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        
        customNavigationbar.setRightSideItems([searchButton, travelButton, myCharacter])
        
        [customNavigationbar, collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            customNavigationbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationbar.topAnchor.constraint(equalTo: topAnchor),
            customNavigationbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: customNavigationbar.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
