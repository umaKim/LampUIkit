//
//  StartPageView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/25.
//

import Combine
import Lottie
import UIKit

enum StartPageViewAction: Actionable {
    case startButtonDidTap
}

final class StartPageView: BaseView<StartPageViewAction> {
    // MARK: - UI Objects
    private lazy var background: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "startImage")
        return imageView
    }()
    private lazy var animaionView = LottieAnimationView(name: "TwinkleAnimation")
    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "startTitle".localized)
        return imageView
    }()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "startButton"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 62).isActive = true
        button.heightAnchor.constraint(equalToConstant: 62).isActive = true
        return button
    }()
    // MARK: - Init
    override init() {
        super.init()
        bind()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind() {
        startButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.startButtonDidTap)
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        animaionView.loopMode = .loop
        animaionView.play()
        addSubviews(background, animaionView, titleImage, startButton)
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.topAnchor.constraint(equalTo: topAnchor),
            animaionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animaionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animaionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            animaionView.topAnchor.constraint(equalTo: topAnchor),
            titleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            startButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
