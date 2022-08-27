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
}

class RecommendedLocationView: BaseWhiteView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<RecommendedLocationViewAction, Never>()
    
//    private(set) lazy var searchButton: UIBarButtonItem = .init(image: UIImage(named: "Search")?.withRenderingMode(.alwaysOriginal),
//                                                                style: .done, target: nil, action: nil)
//    private(set) lazy var myCharacter: UIBarButtonItem = .init(image: .init(systemName: "person")?.withRenderingMode(.alwaysOriginal),
//                                                               style: .done, target: nil, action: nil)
   
    private(set) lazy var customNavigationbar = CustomNavigationBarView()
    
    private(set) var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        cl.minimumLineSpacing = 18
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(SearchRecommendationCollectionViewCell.self, forCellWithReuseIdentifier: SearchRecommendationCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        cv.keyboardDismissMode = .onDrag
        return cv
    }()
    
    private(set) lazy var searchButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "person"), for: .normal)
        return bt
    }()
    
    private(set) lazy var myCharacter: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "house"), for: .normal)
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
            .sink {[unowned self] _ in
                self.actionSubject.send(.search)
            }
            .store(in: &cancellables)
        
        myCharacter
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.myCharacter)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        
        customNavigationbar.setRightSideItems([searchButton, myCharacter])
        
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

class MyLocationHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .robotoBold(18)
        lb.text = "GODOOGODE"
        return lb
    }()
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: 60, height: UIScreen.main.width/2))
        
        backgroundColor = .red
        
        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
    }
    
    public func configure() {
        titleLabel.text = "서울특별시"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
