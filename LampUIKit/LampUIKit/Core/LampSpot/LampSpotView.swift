//
//  LampSpotView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//
import Combine
import CombineCocoa
import UIKit

enum LampSpotViewAction {
    case ar
    case bell
}

class LampSpotView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LampSpotViewAction, Never>()
    
    private(set) var arButton: UIBarButtonItem = {
       let bt = UIBarButtonItem(image: .camera, style: .done, target: nil, action: nil)
        bt.tintColor = .black
        return bt
    }()
    
    private(set) var bellButton: UIBarButtonItem = {
       let bt = UIBarButtonItem(image: .bell, style: .done, target: nil, action: nil)
        bt.tintColor = .black
        return bt
    }()
    
    private(set) var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        cl.minimumLineSpacing = 36
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(MyMapCollectionViewCell.self, forCellWithReuseIdentifier: MyMapCollectionViewCell.identifier)
        cv.register(RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
        cv.register(PopularLampSpotCollectionViewCell.self, forCellWithReuseIdentifier: PopularLampSpotCollectionViewCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .greyshWhite
        return cv
    }()
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        arButton.tapPublisher.sink { _ in
            self.actionSubject.send(.ar)
        }
        .store(in: &cancellables)
        
        bellButton.tapPublisher.sink { _ in
            self.actionSubject.send(.bell)
        }
        .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
