//
//  CompletedTravelHeaderCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/05.
//

import UIKit

final class CompletedTravelHeaderCell: UICollectionReusableView, HeaderCellable {
    static let identifier = "CompletedTravelHeaderCell"
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
