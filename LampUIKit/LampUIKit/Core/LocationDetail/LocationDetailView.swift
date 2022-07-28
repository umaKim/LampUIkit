//
//  LocationDetailView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import Combine
import UIKit

enum LocationDetailViewAction {
    case back
}

final class LocationDetailView: BaseWhiteView {
    
    private(set) lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named:"back")?.withTintColor(.midNavy, renderingMode: .alwaysOriginal)
        let bt = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LocationDetailViewAction, Never>()
    
    private(set) var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        cl.minimumLineSpacing = 18
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(LocationDetailViewHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: LocationDetailViewHeaderCell.identifier)
        cv.register(LocationDetailViewBodyCell.self,
                    forCellWithReuseIdentifier: LocationDetailViewBodyCell.identifier)
        cv.backgroundColor = .greyshWhite
        cv.keyboardDismissMode = .onDrag
        return cv
    }()
    
    override init() {
        super.init()
        
        backButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.back)
            }
            .store(in: &cancellables)
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
