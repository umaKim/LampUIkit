//
//  MyTravelView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//
import Combine
import UIKit

enum MenuTabBarButtonType: Int {
    case myTravel = 0
    case favoritePlace = 1
    case completedTravel = 2
}

class MyTravelView: UIView {
    
    private(set) var arButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .camera, style: .done, target: nil, action: nil)
        bt.tintColor = .black
        return bt
    }()
    private(set) var gearButton : UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .gear, style: .done, target: nil, action: nil)
        bt.tintColor = .black
        return bt
    }()
    
    private let categoryButton = MyTravelCategoryView()
    
    private(set) lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(MyTravelCell.self, forCellWithReuseIdentifier: MyTravelCell.identifier)
        cv.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.identifier)
        cv.register(CompletedTravelCell.self, forCellWithReuseIdentifier: CompletedTravelCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private func scrollTo(item: MenuTabBarButtonType) {
        let indexPath = IndexPath(item: item.rawValue, section: 0)
        collectionView.scrollToItem(at: indexPath,
                                    at: [],
                                    animated: true)
    }
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        categoryButton.actionPublisher
            .sink {[weak self] action in
                switch action {
                case .didTapMyTravel:
                    self?.scrollTo(item: .myTravel)
                    
                case .didTapFavoritePlace:
                    self?.scrollTo(item: .favoritePlace)
                    
                case .didTapCompletedTravel:
                    self?.scrollTo(item: .completedTravel)
                }
            }
            .store(in: &cancellables)
        
        [categoryButton, collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
