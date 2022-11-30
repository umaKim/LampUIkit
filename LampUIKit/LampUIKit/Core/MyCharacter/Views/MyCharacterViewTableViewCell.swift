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
       let label = UILabel()
        label.font = .robotoBold(15)
        label.textColor = .midNavy
        label.text = "Title"
        return label
    }()
    private lazy var barView: HorizontalFillBar = {
        let view = HorizontalFillBar(height: 13, fillerColor: .clear, trackColor: .whiteGrey)
        view.layer.cornerRadius = 13 / 2
        view.heightAnchor.constraint(equalToConstant: 12).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.width - UIScreen.main.width/3).isActive = true
        return view
    }()
    private lazy var numberLabel = CapsuleLabelView("11/50")
    private lazy var seperateView = DividerView()
    public func configure(with data: GaugeData) {
        self.titleLabel.text = data.name.localized
        self.barView.setProgress(
            Float( Double(data.rate) / 50.0),
            animated: true
        )
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
        let stackView = UIStackView(arrangedSubviews: [titleLabel, barView, numberLabel, seperateView])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        [stackView].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
}
