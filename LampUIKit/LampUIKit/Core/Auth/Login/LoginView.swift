//
//  LoginView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//

import AuthenticationServices
import CombineCocoa
import Combine
import UIKit

enum LoginViewAction: Actionable {
    case kakao
    case gmail
    case apple
}

class LoginView: BaseView<LoginViewAction> {
    // MARK: - UI Objects
    private let titleImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "lampTitle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let subTitleImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = .init(named: "loginSubtitle".localized)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let kakao: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakaoButtonKr".localized), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    private let gmail: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "gmailButtonKr".localized), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    private let apple: UIControl = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    private let contractText: UILabel = {
       let label = UILabel()
        label.text = "가입 시 당사의 서비스 약관에 동의하고 개인정보 보호정책을 읽어 당사의 데이터 수집, 사용, 공유방법을 확인했음을 인정합니다".localized
        label.textAlignment = .center
        label.numberOfLines = 10
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .bluePurple
        return label
    }()
    // MARK: - Init
    override init() {
        super.init()
        bind()
        setupUI()
    }
    // MARK: - Bind
    private func bind() {
        kakao
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.sendAction(.kakao)
            }
            .store(in: &cancellables)
        gmail
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.sendAction(.gmail)
            }
            .store(in: &cancellables)
        apple
            .addTarget(
                self,
                action: #selector(appleSignInButtonPress),
                for: .touchUpInside
            )
    }
    @objc
    private func appleSignInButtonPress() {
        self.sendAction(.apple)
    }
    private func setupUI() {
        backgroundColor = .darkNavy
        let stackView = UIStackView(arrangedSubviews: [kakao, gmail, apple])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        let imageSv = UIStackView(arrangedSubviews: [subTitleImage, UIView()])
        imageSv.axis = .horizontal
        imageSv.distribution = .fill
        imageSv.alignment = .leading
        let totalStackView = UIStackView(arrangedSubviews: [titleImage, imageSv, stackView])
        totalStackView.axis = .vertical
        totalStackView.spacing = UIScreen.main.height/15
        totalStackView.distribution = .fill
        totalStackView.alignment = .fill
        [totalStackView, contractText].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            totalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            totalStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(UIScreen.main.height / 15)),
            totalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contractText.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            contractText.centerXAnchor.constraint(equalTo: centerXAnchor),
            contractText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            contractText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
