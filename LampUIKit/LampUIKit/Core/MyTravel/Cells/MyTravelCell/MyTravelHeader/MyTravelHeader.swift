//
//  MyTravelHeader.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/28.
//
import Combine
import UIKit

protocol MyTravelCellHeaderCellDelegate:AnyObject {
    func myTravelCellHeaderCellDidSelectEdit()
    func myTravelCellHeaderCellDidSelectComplete()
}

final class MyTravelCellHeaderCell: UICollectionReusableView {
    static let identifier = "MyTravelCellHeaderCell"
    
    weak var delegate: MyTravelCellHeaderCellDelegate?
    
    private lazy var goalDateLabel: UILabel = {
       let ul = UILabel()
        ul.text = "목표 날짜"
        ul.textColor = .black
        ul.font = .systemFont(ofSize: 15, weight: .semibold)
        return ul
    }()
    
    private lazy var editButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("편집", for: .normal)
        bt.setTitleColor(.midNavy, for: .normal)
        return bt
    }()
    
    private var isEditButtonTapped: Bool = false
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        editButton
            .tapPublisher
            .sink { _ in
                self.isEditButtonTapped.toggle()
                if self.isEditButtonTapped {
                    self.editButton.setTitle("완료", for: .normal)
                    self.delegate?.myTravelCellHeaderCellDidSelectEdit()
                } else {
                    self.editButton.setTitle("편집", for: .normal)
                    self.delegate?.myTravelCellHeaderCellDidSelectComplete()
                }
            }
            .store(in: &cancellables)
        
        [editButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
