//
//  MyCharacterViewTableViewHeaderCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/29.
//

import UIKit

class MyCharacterViewTableViewHeaderCell: UITableViewHeaderFooterView {
    static let identifier = "MyCharacterViewTableViewHeaderCell"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "My Lampie"
        lb.font = .robotoBold(28)
        lb.textColor = .midNavy
        lb.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 2).isActive = true
        return lb
    }()
    
    private lazy var levelLabel: UILabel = {
        let lb = UILabel()
        lb.text = "LV.\(1)"
        lb.font = .robotoMedium(22)
        lb.textColor = .midNavy
        lb.textAlignment = .right
        return lb
    }()
    
    private lazy var characterImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage()
        uv.backgroundColor = .midNavy
        uv.layer.cornerRadius = 7
        
        uv.widthAnchor.constraint(equalToConstant: 145).isActive = true
        uv.heightAnchor.constraint(equalToConstant: 145).isActive = true
        return uv
    }()
    
    private lazy var averageStat: GraphHeaderView = {
       let uv = GraphHeaderView("평균스탯", number: 0)
        uv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return uv
    }()
    
    private lazy var mileageStat: GraphHeaderView = {
       let uv = GraphHeaderView("마일리지", number: 0)
        uv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return uv
    }()
    
    private lazy var mileageView = MileageView()
    
    private func setupUI() {
        contentView.backgroundColor = .greyshWhite
        
        let titleSv = UIStackView(arrangedSubviews: [nameLabel, levelLabel])
        titleSv.axis = .horizontal
        titleSv.distribution = .fill
        titleSv.alignment = .fill
        
        let statSv = UIStackView(arrangedSubviews: [averageStat, mileageStat])
        statSv.axis = .vertical
        statSv.distribution = .fillEqually
        statSv.alignment = .fill
        statSv.spacing = 16
        
        [titleSv, characterImageView, statSv, mileageView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleSv.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleSv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleSv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            characterImageView.topAnchor.constraint(equalTo: titleSv.bottomAnchor, constant: 17),
            characterImageView.leadingAnchor.constraint(equalTo: titleSv.leadingAnchor),
            
            statSv.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),
            statSv.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            statSv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            mileageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mileageView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            mileageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    public func configure(with character: CharacterData) {
        averageStat.setValue(20)
        mileageStat.setValue(50)
    }
}
