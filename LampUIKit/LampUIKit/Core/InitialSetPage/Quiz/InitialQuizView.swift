//
//  InitialQuizView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//

import CombineCocoa
import Combine
import UIKit

enum InitialQuizViewAction {
    case button1
    case button2
    case button3
    case button4
    case button5
    case next
}

class AnswerButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .darkNavy
        layer.borderWidth = 2
        layer.borderColor = UIColor.midNavy.cgColor
        layer.cornerRadius = 5
        widthAnchor.constraint(equalToConstant: 280).isActive = true
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        titleLabel?.numberOfLines = 0; // Dynamic number of lines
        titleLabel?.lineBreakMode = .byWordWrapping;
        titleLabel?.textAlignment = .center
        titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        
        clipsToBounds = true
        
        titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InitialQuizView: BaseView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<InitialQuizViewAction, Never>()
    
    private let quizView = QuizView()
    private let resultView = QuizResultView()
    
    override init() {
        super.init()
        
        backgroundColor = .darkNavy
        
        bind()
        setupUI()
    }
    
    private func bind() {
        quizView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .button1:
                    self.actionSubject.send(.button1)
                    
                case .button2:
                    self.actionSubject.send(.button2)
                    
                case .button3:
                    self.actionSubject.send(.button3)
                    
                case .button4:
                    self.actionSubject.send(.button4)
                    
                case .button5:
                    self.actionSubject.send(.button5)
                    
                case .next:
                    self.actionSubject.send(.next)
                }
            }
            .store(in: &cancellables)
        
        resultView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .next:
                    self.actionSubject.send(.next)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        [quizView, resultView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            quizView.leadingAnchor.constraint(equalTo: leadingAnchor),
            quizView.trailingAnchor.constraint(equalTo: trailingAnchor),
            quizView.bottomAnchor.constraint(equalTo: bottomAnchor),
            quizView.topAnchor.constraint(equalTo: topAnchor),
            
            resultView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultView.topAnchor.constraint(equalTo: topAnchor),
        ])
        
        resultView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setQuizData(_ data: Question) {
        quizView.setQuizData(data)
    }
    
    public func setCharacterImage(_ image: UIImage) {
        quizView.isHidden = true
        resultView.isHidden = false
        
        resultView.setupCharacter(image)
    }
}
