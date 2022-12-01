//
//  GraphHeaderView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//

import UIKit

final class GraphHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "평균 스탯"
        label.textColor = .lightNavy
        label.font = .robotoBold(13)
        return label
    }()
    private lazy var numberLabel: CapsuleLabelView = {
       let uiView = CapsuleLabelView("")
        uiView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return uiView
    }()
    private lazy var graphView = HorizontalFillBar(height: 13, fillerColor: .systemGreen, trackColor: .whiteGrey)
    public var barColor: UIColor? {
        didSet {
            self.graphView.barColor = barColor
        }
    }
    init(
        _ title: String,
        number: Int,
        color: UIColor = .systemGray
    ) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setValue(
        _ numerator: Float,
        _ denomenator: Float
    ) {
        numberLabel.setText("\(Int(numerator)) / \(Int(denomenator))")
        graphView.setProgress(numerator/denomenator, animated: true)
    }
    private func setupUI() {
        let headerSv = UIStackView(arrangedSubviews: [titleLabel, numberLabel])
        headerSv.axis = .horizontal
        headerSv.distribution = .fill
        headerSv.alignment = .fill
        let totalSv = UIStackView(arrangedSubviews: [headerSv, graphView])
        totalSv.axis = .vertical
        totalSv.distribution = .equalSpacing
        totalSv.alignment = .fill
        totalSv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalSv)
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalSv.bottomAnchor.constraint(equalTo: bottomAnchor),
            totalSv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
