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
    
//    private(set) lazy var actionPublisher = acrtionSubject.eraseToAnyPublisher()
//    private let acrtionSubject = PassthroughSubject<StartPageViewAction, Never>()
    
    private lazy var background: UIImageView = {
        let uv = UIImageView()
        uv.image = UIImage(named: "startImage")
        return uv
    }()
    
    private lazy var animaionView = AnimationView(name: "TwinkleAnimation")
    
    private lazy var titleImage: UIImageView = {
        let uv = UIImageView()
        uv.image = UIImage(named: "startTitle".localized)
        return uv
    }()
    
    private lazy var startButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "startButton"), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 62).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 62).isActive = true
        return bt
    }()
    
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
            .sink { _ in
                self.sendAction(.startButtonDidTap)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        
        animaionView.loopMode = .loop
        animaionView.play()
        
        [background, animaionView, titleImage, startButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
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
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
