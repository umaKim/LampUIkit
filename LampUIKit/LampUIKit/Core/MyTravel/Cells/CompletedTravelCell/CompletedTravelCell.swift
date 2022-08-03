//
//  CompletedTravelCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/18.
//

import UIKit

final class CompletedTravelHeaderCell: UICollectionReusableView {
    static let identifier = "CompletedTravelHeaderCell"
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CompletedTravelCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "CompletedTravelCellCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
