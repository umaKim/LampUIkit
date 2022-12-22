//
//  QuizView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//
import Combine
import UIKit

enum QuizViewAction: Actionable {
    case button1
    case button2
    case button3
    case button4
    case button5
    case next
}

final class QuizView: BaseView<QuizViewAction> {
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
    private lazy var twinkle1: UIImageView = {
       let imageView = UIImageView()
        imageView.image = .init(named: "twinkle1")
        return imageView
    }()
    private lazy var twinkle2: UIImageView = {
       let imageView = UIImageView()
        imageView.image = .init(named: "twinkle2")
        return imageView
    }()
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .midNavy
        label.numberOfLines = 0
        label.textAlignment = .center
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.width/1.5).isActive = true
        return label
    }()
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .lightNavy
        return label
    }()
    private lazy var button1 = AnswerButton()
    private lazy var button2 = AnswerButton()
    private lazy var button3 = AnswerButton()
    private lazy var button4 = AnswerButton()
    private lazy var button5 = AnswerButton()
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "quizNextButton"), for: .normal)
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
    private func resetAllButtonBackGroundColor() {
        [button1, button2, button3, button4, button5].forEach { uiView in
            uiView.backgroundColor = .darkNavy
            uiView.isSelected = false
        }
    }
    private func buttonToggle(_ button: UIButton) {
        resetAllButtonBackGroundColor()
        button.isSelected.toggle()
        button.backgroundColor = button.isSelected ? .midNavy : .darkNavy
    }
    public func setQuizData(_ data: Question) {
        questionLabel.text = data.title?.localized
        indexLabel.text = "\(data.surveyIdx)" + " / 6"
        button1.setTitle(data.option1?.localized, for: .normal)
        button2.setTitle(data.option2?.localized, for: .normal)
        button3.setTitle(data.option3?.localized, for: .normal)
        if data.option4 == nil {
            button4.isHidden = true
        } else {
            button4.isHidden = false
            button4.setTitle(data.option4?.localized, for: .normal)
        }
        if data.option5 == nil {
            button5.isHidden = true
        } else {
            button5.isHidden = false
            button5.setTitle(data.option5?.localized, for: .normal)
        }
    }
}

// MARK: - Bind
extension QuizView {
    private func bind() {
        button1.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.sendAction(.button1)
            self.buttonToggle(self.button1)
        }
        .store(in: &cancellables)
        button2.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.sendAction(.button2)
            self.buttonToggle(self.button2)
        }
        .store(in: &cancellables)
        button3.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.sendAction(.button3)
            self.buttonToggle(self.button3)
        }
        .store(in: &cancellables)
        button4.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.sendAction(.button4)
            self.buttonToggle(self.button4)
        }
        .store(in: &cancellables)
        button5.tapPublisher.sink {[weak self] _ in
            guard let self = self else { return }
            self.sendAction(.button5)
            self.buttonToggle(self.button5)
        }
        .store(in: &cancellables)
        nextButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                UIView.transition(
                    with: self.backgroundImageView,
                    duration: 1,
                    options: .curveEaseInOut,
                    animations: nil,
                    completion: nil
                )
                self.sendAction(.next)
                self.resetAllButtonBackGroundColor()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Setup UI
extension QuizView {
    private func setupUI() {
        let buttonSv = UIStackView(arrangedSubviews: [button1, button2, button3, button4, button5])
        buttonSv.axis = .vertical
        buttonSv.alignment = .center
        buttonSv.distribution = .equalSpacing
        buttonSv.spacing = 20

        let totalSv = UIStackView(arrangedSubviews: [questionLabel, indexLabel, buttonSv])
        totalSv.axis = .vertical
        totalSv.alignment = .center
        totalSv.distribution = .fillProportionally
        totalSv.spacing = 40
        addSubviews(backgroundImageView, logoImageView, twinkle1, twinkle2, totalSv, nextButton)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backgroundImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            backgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            twinkle1.trailingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
            twinkle1.bottomAnchor.constraint(equalTo: questionLabel.topAnchor),
            twinkle2.leadingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            twinkle2.topAnchor.constraint(equalTo: questionLabel.bottomAnchor),
            totalSv.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            totalSv.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -(UIScreen.main.height / 70)),
            logoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor ),
            logoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
