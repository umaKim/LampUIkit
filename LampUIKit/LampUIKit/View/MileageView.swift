//
//  MileageView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//

import UIKit

class MileageView: UIView {
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "마일리지".localized + ": "
        lb.font = .systemFont(ofSize: 16, weight: .semibold)
        lb.textColor = .white
        return lb
    }()
    private let valueLabel: UILabel = {
       let lb = UILabel()
        lb.font = .robotoBold(16)
        lb.textColor = .white
        return lb
    }()
    private let twinkle1: UIImageView = {
      let uv = UIImageView()
        uv.image = .init(named: "twinkle1")
        return uv
    }()
    private let twinkle2: UIImageView = {
       let uv = UIImageView()
        uv.image = .init(named: "twinkle2")
        return uv
    }()
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 6
        backgroundColor = .lightNavy
        widthAnchor.constraint(equalToConstant: UIScreen.main.width).isActive = true
        heightAnchor.constraint(equalToConstant: 64).isActive = true
        let sv = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .horizontal
        [sv, twinkle1, twinkle2].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        NSLayoutConstraint.activate([
            twinkle1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            twinkle1.centerYAnchor.constraint(equalTo: centerYAnchor),
            twinkle2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            twinkle2.centerYAnchor.constraint(equalTo: centerYAnchor),
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setValue(_ value: String) {
        valueLabel.text = value
    }
}
