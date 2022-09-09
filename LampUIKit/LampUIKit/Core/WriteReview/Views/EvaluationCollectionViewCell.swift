//
//  EvaluationCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import UIKit

final class EvaluationCollectionViewCell: UICollectionViewCell {
    static let identifier = "EvaluationCollectionViewCell"
    
    static let preferredHeight: CGFloat = 30
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = EvaluationCollectionViewCell.preferredHeight / 2
        layer.borderWidth = 1
        
        setupUI()
    }
    
    private func setupUI() {
        [titleLabel].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: EvaluationModel) {
        titleLabel.text = model.title.localized
        
        if model.isSelected {
            self.layer.borderColor = UIColor.lightNavy.cgColor
            self.titleLabel.textColor = .lightNavy
            self.titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
            self.layer.borderWidth = 2
        } else {
            self.layer.borderColor = UIColor.systemGray.cgColor
            self.titleLabel.textColor = .systemGray
            self.titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            self.layer.borderWidth = 1
        }
    }
}
