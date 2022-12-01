//
//  HorizontalFillBar.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//

import UIKit

final class HorizontalFillBar: UIProgressView {
    private let height: CGFloat
    init(
        height: CGFloat,
        fillerColor: UIColor,
        trackColor: UIColor
    ) {
        self.height = height
        super.init(frame: .zero)
        progressViewStyle = .bar
        progressTintColor = fillerColor
        trackTintColor = trackColor
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    public var barColor: UIColor? {
        didSet {
            progressTintColor = barColor
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height / 2
        clipsToBounds = true
    }
}
