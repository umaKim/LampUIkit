//
//  File.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/28.
//
import Combine
import UIKit

protocol MyTravelCellCollectionViewCellDelegate: AnyObject {
    func myTravelCellCollectionViewCellDidTapDelete(at index: Int)
}

final class MyTravelCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyTravelCellCollectionViewCell"
    
    private let containerView: UIView = {
        let uv = UIView()
        uv.layer.cornerRadius = 6
        uv.layer.borderColor = UIColor.systemGray.cgColor
        uv.backgroundColor = .greyshWhite
        return uv
    }()
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "경복궁"
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        lb.numberOfLines = 1
        
        return lb
    }()
    
    private lazy var pinImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = .init(systemName: "person")
        uv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        uv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return uv
    }()
    
    private lazy var timeLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        lb.text = "09:00~18:30 (입장마감은 17:30)"
        lb.textColor = .midNavy
        return lb
    }()
    
    private lazy var addressLabel: UILabel = {
       let lb = UILabel()
        lb.text = "주소 어쩌구 저쩌구"
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        return lb
    }()
    
    private lazy var deleteButton: UIButton = {
       let bt = UIButton()
        let image = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        bt.setImage(image, for: .normal)
        bt.isHidden = true
        return bt
    }()
        configureShadow(0.4)
        
        let totalSv = UIStackView(arrangedSubviews: [titleLabel, timeLabel, addressLabel])
        totalSv.axis = .vertical
        totalSv.alignment = .fill
        totalSv.distribution = .fill
        totalSv.spacing = 6
        
        [containerView, totalSv, deleteButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            
            totalSv.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            totalSv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            totalSv.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
