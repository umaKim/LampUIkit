//
//  LoginView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//

import CombineCocoa
import Combine
import UIKit

enum LoginViewAction {
    case kakao
    case gmail
    case apple
}

class LoginView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LoginViewAction, Never>()
    
    private let titleImage: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(named: "lampTitle")
        return uv
    }()
    
    private let kakao: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "kakaoButton"), for: .normal)
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return bt
    }()
    
    private let gmail: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "gmailButton"), for: .normal)
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return bt
    }()
    
    private let apple: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "appleButton"), for: .normal)
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return bt
    }()
    
    private let contractText: UILabel = {
       let lb = UILabel()
        lb.text = "가입 시 당사의 서비스 약관에 동의하고 개인정보 보호정책을 읽어 당사의 데이터 수집, 사용, 공유방법을 확인했음을 인정합니다"
        lb.textAlignment = .center
        lb.numberOfLines = 10
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        return lb
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        backgroundColor = .darkNavy
        
        kakao.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.actionSubject.send(.kakao)
        }
        .store(in: &cancellables)
        
        gmail.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.actionSubject.send(.gmail)
        }
        .store(in: &cancellables)
        
        apple.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.actionSubject.send(.apple)
        }
        .store(in: &cancellables)
        
        let stackView = UIStackView(arrangedSubviews: [kakao, gmail, apple])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        [titleImage, stackView, contractText].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
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
