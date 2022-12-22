//
//  InitialQuizView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//

import CombineCocoa
import Combine
import UIKit

enum InitialQuizViewAction: Actionable {
    case button1
    case button2
    case button3
    case button4
    case button5
    case next
}

final class InitialQuizView: BaseView<InitialQuizViewAction> {
    private let quizView = QuizView()
    private let resultView = QuizResultView()
    // MARK: - Init
    override init() {
        super.init()
        backgroundColor = .darkNavy
        bind()
        setupUI()
    }
    // MARK: - Bind
    private func bind() {
        quizView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .button1:
                    self.sendAction(.button1)
                case .button2:
                    self.sendAction(.button2)
                case .button3:
                    self.sendAction(.button3)
                case .button4:
                    self.sendAction(.button4)
                case .button5:
                    self.sendAction(.button5)
                case .next:
                    self.sendAction(.next)
                }
            }
            .store(in: &cancellables)
        resultView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .next:
                    self.sendAction(.next)
                }
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        addSubviews(quizView, resultView)
        NSLayoutConstraint.activate([
            quizView.leadingAnchor.constraint(equalTo: leadingAnchor),
            quizView.trailingAnchor.constraint(equalTo: trailingAnchor),
            quizView.bottomAnchor.constraint(equalTo: bottomAnchor),
            quizView.topAnchor.constraint(equalTo: topAnchor),
            resultView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultView.topAnchor.constraint(equalTo: topAnchor)
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
