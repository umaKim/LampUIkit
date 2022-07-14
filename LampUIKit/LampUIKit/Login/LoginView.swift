//
//  LoginView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//

import UIKit

class LoginView: UIView {
    
    private let kakao = RectangleTextButton("카카오", background: .yellow)
    private let gmail = RectangleTextButton("gmail", background: .orange)
    private let apple = RectangleTextButton("Apple", background: .white)
    
    private let contractText: UILabel = {
       let lb = UILabel()
        lb.text = "가입 시 당사의 서비스 약관에 동의하고 개인정보 보호정책을 읽어 당사의 데이터 수집, 사용, 공유방법을 확인했음을 인정합니다"
        lb.textAlignment = .center
        lb.numberOfLines = 10
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        return lb
    }()
    
    init() {
        super.init(frame: .zero)
        
        let stackView = UIStackView(arrangedSubviews: [kakao, gmail, apple])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        [stackView, contractText].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contractText.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 64),
            contractText.centerXAnchor.constraint(equalTo: centerXAnchor),
            contractText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            contractText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
