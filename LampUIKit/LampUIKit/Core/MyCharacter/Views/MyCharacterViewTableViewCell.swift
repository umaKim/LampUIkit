//
//  MyCharacterViewTableViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/29.
//

import UIKit

class MyCharacterViewTableViewCell: UITableViewCell {
    static let identifier = "MyCharacterViewTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .robotoBold(15)
        lb.textColor = .midNavy
        lb.text = "Title"
        return lb
    }()
    
    private lazy var barView: HorizontalFillBar = {
        let uv = HorizontalFillBar(height: 13, fillerColor: .clear, trackColor: .whiteGrey)
        uv.layer.cornerRadius = 13 / 2
        uv.heightAnchor.constraint(equalToConstant: 12).isActive = true
        uv.widthAnchor.constraint(equalToConstant: UIScreen.main.width - UIScreen.main.width/3).isActive = true
        return uv
    }()
    
    private lazy var numberLabel = CapsuleLabelView("11/50")
    
    private lazy var seperateView = DividerView()
    
    public func configure(with data: GaugeData) {
        self.titleLabel.text = data.name.localized
        self.barView.setProgress(Float( Double(data.rate) / 50.0),
                                 animated: true)
        numberLabel.setText("\(data.rate) / 50")
        
        if data.name == "탐구 게이지" {
            barView.barColor = .systemGreen
        } else if data.name == "인싸 게이지" {
            barView.barColor = .systemRed
        } else if data.name == "여행 게이지" {
            barView.barColor = .systemBlue
        }
    }
    
    private func setupUI() {
        backgroundColor = .greyshWhite
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, barView, numberLabel, seperateView])
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.axis = .vertical
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            sv.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
}
