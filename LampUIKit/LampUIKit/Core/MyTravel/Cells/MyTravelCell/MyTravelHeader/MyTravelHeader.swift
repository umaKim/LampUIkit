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
    
    private lazy var editButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.titleLabel?.font = .boldSystemFont(ofSize: 15)
        bt.setTitle("편집".localized, for: .normal)
        bt.setTitleColor(.midNavy, for: .normal)
        return bt
    }()
    
    private var isEditButtonTapped: Bool = false
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        editButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                HapticManager.shared.feedBack(with: .rigid)
                self.isEditButtonTapped.toggle()
                if self.isEditButtonTapped {
                    self.editButton.setTitle("완료".localized, for: .normal)
                    self.delegate?.myTravelCellHeaderCellDidSelectEdit()
                } else {
                    self.editButton.setTitle("편집".localized, for: .normal)
                    self.delegate?.myTravelCellHeaderCellDidSelectComplete()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
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
