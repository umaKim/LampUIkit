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
    
    public func setupCharacter(_ data: CharacterData) {
        
    public func setTags(_ tags: [String]) {
        capsuelLabel1.setText(tags[0])
        capsuelLabel2.setText(tags[1])
        capsuelLabel3.setText(tags[2])
    }
    
    private func bind() {
        nextButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.next)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        capsuelLabel1.layer.borderWidth = 1
        capsuelLabel1.layer.borderColor = UIColor.midNavy.cgColor
        
        capsuelLabel2.layer.borderWidth = 1
        capsuelLabel2.layer.borderColor = UIColor.midNavy.cgColor
        
        capsuelLabel3.layer.borderWidth = 1
        capsuelLabel3.layer.borderColor = UIColor.midNavy.cgColor
        
        let hsv = UIStackView(arrangedSubviews: [capsuelLabel1, capsuelLabel2, capsuelLabel3])
        hsv.axis = .horizontal
        hsv.alignment = .fill
        hsv.distribution = .equalSpacing
        hsv.spacing = 8
        hsv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let sv = UIStackView(arrangedSubviews: [hsv, instructionLabel])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        sv.spacing = 6
        
        [backgroundImageView, logoImageView, welcomeTitleLabel, characterImageView, sv, nextButton].forEach { uv in
            addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backgroundImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            backgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            welcomeTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeTitleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 36),
            
            characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: backgroundImageView.frame.width),
            characterImageView.heightAnchor.constraint(equalToConstant: backgroundImageView.frame.width),
            characterImageView.topAnchor.constraint(equalTo: welcomeTitleLabel.bottomAnchor),
            
            hsv.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            hsv.bottomAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 36),
            
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -(UIScreen.main.height / 70)),
            
            logoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor ),
            logoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}
