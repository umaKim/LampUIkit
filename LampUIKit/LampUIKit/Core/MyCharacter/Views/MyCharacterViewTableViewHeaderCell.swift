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
        let label = UILabel()
        label.text = "My Lampie"
        label.font = .robotoBold(28)
        label.textColor = .midNavy
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 2).isActive = true
        return lb
    }()
    
    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.text = "LV.\(1)"
        label.font = .robotoMedium(22)
        label.textColor = .midNavy
        label.textAlignment = .right
        return label
    }()
    
    private lazy var characterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7
        imageView.widthAnchor.constraint(equalToConstant: 145).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 145).isActive = true
        return uv
    }()
    
    private lazy var averageStat: GraphHeaderView = {
        let view = GraphHeaderView("평균 스탯".localized, number: 0)
        view.barColor = .systemBlue
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    private lazy var mileageView = MileageView()
    
    private func setupUI() {
        contentView.backgroundColor = .greyshWhite
        let titleSv = UIStackView(arrangedSubviews: [nameLabel, levelLabel])
        titleSv.axis = .horizontal
        titleSv.distribution = .fill
        titleSv.alignment = .fill
        let statSv = UIStackView(arrangedSubviews: [averageStat])
        statSv.axis = .vertical
        statSv.distribution = .fillEqually
        statSv.alignment = .fill
        statSv.spacing = 16
        [titleSv, characterImageView, statSv, mileageView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        NSLayoutConstraint.activate([
            titleSv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
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
        characterImageView.sd_setImage(
            with: URL(string: character.imageString ?? ""),
            placeholderImage: .placeholder
        )
        nameLabel.text = character.characterName
        levelLabel.text = "LV.\(character.level)"
        if let avg = Float(character.averageStat) {
            averageStat.setValue(avg, 200)
        }
        mileageView.setValue(character.mileage)
    }
}
