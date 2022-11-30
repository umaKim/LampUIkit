//
//  RoundedLabelView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import Combine
import UIKit

class RoundedLabelView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    }()
    public func setText(_ text: String) {
        self.label.text = text
    }
    public func setRound(_ isRounded: Bool) {
        self.isRounded = isRounded
    }
    private var isRounded: Bool
    init(
        _ text: String,
        isRounded: Bool = true
    ) {
        self.label.text = text
        self.isRounded = isRounded
        super.init(frame: .zero)
        [label].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRounded {
            layer.borderWidth = 1
            layer.borderColor = UIColor.midNavy.cgColor
            layer.cornerRadius = self.frame.height / 2
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
