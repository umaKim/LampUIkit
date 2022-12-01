//
//  QuizResultView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//

import CombineCocoa
import Combine
import UIKit

enum QuizResultViewAction: Actionable {
    case next
}

class QuizResultView: BaseView<QuizResultViewAction> {
    // MARK: - UI Objects
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "testBackground"))
        return imageView
    }()
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "lampTitle"))
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    private lazy var characterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "next_downArrow"), for: .normal)
        return button
    }()
    // MARK: - Init
    override init() {
        super.init()
        backgroundColor = .darkNavy
        bind()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setupCharacter(_ image: UIImage) {
        characterImageView.image = image
    }
    private func bind() {
        nextButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.next)
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        [backgroundImageView, logoImageView, characterImageView, nextButton].forEach { uiView in
            addSubview(uiView)
            uiView.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backgroundImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            backgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16),
            characterImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -16),
            characterImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 26),
            characterImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -80),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -(UIScreen.main.height / 70)),
            logoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor ),
            logoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
