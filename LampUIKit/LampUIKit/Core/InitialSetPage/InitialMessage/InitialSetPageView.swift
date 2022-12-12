//
//  InitialSetPageView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//

import UIKit

enum InitialSetPageViewAction: Actionable { }

class InitialSetPageView: BaseView<InitialSetPageViewAction> {
    private lazy var beginningMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.alpha = 1
        label.numberOfLines = 4
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private lazy var darkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "darkCircle"))
        return imageView
    }()
    private lazy var twinkles: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "aroundTwinkles"))
        return imageView
    }()
    private var runCount = 0
    override init() {
        super.init()
        backgroundColor = .darkNavy
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods
extension InitialSetPageView {
    public func animateBeginningMessageLabel(with messages: [String], completion: @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[weak self] timer in
            guard let self = self else { return }
            if self.runCount == 3 {
                timer.invalidate()
                completion()
            } else {
                print(self.runCount)
                UIView.transition(
                    with: self.beginningMessageLabel,
                    duration: 0.25,
                    options: .transitionFlipFromBottom
                ) { [weak self] in
                    self?.beginningMessageLabel.text = messages[self?.runCount ?? 0]
                }
            }
            self.runCount += 1
        }
    }
}

// MARK: - Private methods
extension InitialSetPageView {
    private func setupUI() {
        addSubviews(darkImageView, twinkles, beginningMessageLabel)
        NSLayoutConstraint.activate([
            darkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            darkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            twinkles.centerXAnchor.constraint(equalTo: centerXAnchor),
            twinkles.centerYAnchor.constraint(equalTo: centerYAnchor),
            beginningMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            beginningMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
