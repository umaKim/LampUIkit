//
//  QuizResultView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//

import CombineCocoa
import Combine
import UIKit

enum QuizResultViewAction {
    case next
}

class QuizResultView: BaseView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<QuizResultViewAction, Never>()
    
    private lazy var backgroundImageView: UIImageView = {
        let uv = UIImageView(image: UIImage(named: "testBackground"))
        return uv
    }()
    
    private lazy var logoImageView: UIImageView = {
        let uv = UIImageView(image: UIImage(named: "lampTitle"))
        uv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        uv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return uv
    }()
    
    private lazy var welcomeTitleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .robotoBold(20)
        lb.textAlignment = .center
        lb.textColor = .darkNavy
        lb.numberOfLines = 0
        lb.text = "축하드려요~ \n당신과 함께 할 캐릭터는~~"
        return lb
    }()
    
    private lazy var characterImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(systemName: "person")
        uv.backgroundColor = .red
        return uv
    }()
    
    private lazy var capsuelLabel1 = CapsuleLabelView("고즈넉한", backgroundColor: .white, textColor: .midNavy, textSize: 12)
    private lazy var capsuelLabel2 = CapsuleLabelView("고즈넉한", backgroundColor: .white, textColor: .midNavy, textSize: 12)
    private lazy var capsuelLabel3 = CapsuleLabelView("고즈넉한", backgroundColor: .white, textColor: .midNavy, textSize: 12)
    
    private lazy var instructionLabel: UILabel = {
       let lb = UILabel()
        lb.text = "이 태그를 중심으로 여행지를 추천해드려요"
        lb.font = .robotoBold(14)
        lb.textColor = .black
        return lb
    }()
    
    private lazy var nextButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "next_downArrow"), for: .normal)
        return bt
    }()
    
    override init() {
        super.init()
        
        backgroundColor = .darkNavy
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    }
    
    private func bind() {
        nextButton
            .tapPublisher
            .sink {[unowned self] _ in
                self.actionSubject.send(.next)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
            addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backgroundImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            backgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -(UIScreen.main.height / 70)),
            
            logoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor ),
            logoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}
