//
//  FavoriteHeaderCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/28.
//
import Combine
import UIKit

protocol FavoriteCellHeaderCellDelegate: AnyObject {
    func favoriteCellHeaderCellDidSelectEdit()
    func favoriteCellHeaderCellDidSelectComplete()
}

final class FavoriteCellHeaderCell: UICollectionReusableView, HeaderCellable {
    static let identifier = "FavoriteCellHeaderCell"
    weak var delegate: FavoriteCellHeaderCellDelegate?
    private var isEditButtonTapped: Bool = false
    private var cancellables: Set<AnyCancellable>
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
