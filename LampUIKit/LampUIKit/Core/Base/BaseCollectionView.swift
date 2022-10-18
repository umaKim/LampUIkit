//
//  BaseCollectionView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/04.
//

import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

protocol HeaderCellable: UICollectionReusableView, Identifiable { }

protocol BodyCellable: UICollectionViewCell, Identifiable { }

class BaseCollectionViewWithHeader<HEADERCELL: HeaderCellable, BODYCELL: BodyCellable>: UICollectionView {
    
    init(
        _ collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    ) {
        super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        
        register(HEADERCELL.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HEADERCELL.identifier)
        register(BODYCELL.self, forCellWithReuseIdentifier: BODYCELL.identifier)
        backgroundColor = .greyshWhite
    }
    
    convenience init(
        _ scrollDirection: UICollectionView.ScrollDirection = .vertical
    ) {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = scrollDirection
        self.init(cl)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseCollectionView<BODYCELL: BodyCellable>: UICollectionView {
    init(
        _ collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    )  {
        super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        
        register(BODYCELL.self, forCellWithReuseIdentifier: BODYCELL.identifier)
        backgroundColor = .greyshWhite
    }
    
    convenience init(
        _ scrollDirection: UICollectionView.ScrollDirection = .vertical,
        _ minimumLineSpacing: CGFloat = 16
    ) {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = scrollDirection
        collectionViewFlowLayout.minimumLineSpacing = minimumLineSpacing
        self.init(collectionViewFlowLayout)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
