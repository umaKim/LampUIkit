//
//  MyPageTableViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    static let identifier = "MyPageTableViewCell"
    
    private let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 16, weight: .semibold)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .greyshWhite
        
        [titleLabel].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with title: String) {
        self.titleLabel.text = title.localized
    }
}
