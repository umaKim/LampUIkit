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
    
    private let titleImage: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(named: "lampTitle")
        uv.contentMode = .scaleAspectFit
        return uv
    }()
    
    private let subTitleImage: UIImageView = {
       let uv = UIImageView()
        uv.image = .init(named: "loginSubtitle".localized)
        uv.contentMode = .scaleAspectFit
        return uv
    }()
    
    private let kakao: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "kakaoButtonKr".localized), for: .normal)
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return bt
    }()
    
    private let gmail: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "gmailButtonKr".localized), for: .normal)
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return bt
    }()
    
    private let apple:  UIControl = {
        let bt = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return bt
    }()
    
    private let contractText: UILabel = {
       let lb = UILabel()
        lb.text = "가입 시 당사의 서비스 약관에 동의하고 개인정보 보호정책을 읽어 당사의 데이터 수집, 사용, 공유방법을 확인했음을 인정합니다".localized
        lb.textAlignment = .center
        lb.numberOfLines = 10
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        lb.textColor = .bluePurple
        return lb
    }()
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    private func bind() {
        kakao.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.sendAction(.kakao)
        }
        .store(in: &cancellables)
        
        gmail.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.sendAction(.gmail)
        }
        .store(in: &cancellables)
        
        apple.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
    }
    
    @objc private func appleSignInButtonPress() {
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
        
        [totalStackView, contractText].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
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
