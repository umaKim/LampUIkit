//
//  QuizView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//
import Combine
import UIKit

enum QuizViewAction {
    case button1
    case button2
    case button3
    case button4
    case button5
    case next
}

class QuizView: BaseView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<QuizViewAction, Never>()
    
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
    
    private lazy var questionLabel: UILabel = {
        let lb = UILabel()
        lb.font = .robotoBold(20)
        lb.textColor = .midNavy
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.widthAnchor.constraint(equalToConstant: UIScreen.main.width/1.5).isActive = true
        return lb
    }()
    
    private lazy var indexLabel: UILabel = {
        let lb = UILabel()
        lb.font = .robotoRegular(16)
        lb.textColor = .midNavy
        return lb
    }()
    
    private lazy var button1 = AnswerButton()
    private lazy var button2 = AnswerButton()
    private lazy var button3 = AnswerButton()
    private lazy var button4 = AnswerButton()
    private lazy var button5 = AnswerButton()
    
    private lazy var nextButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "quizNextButton"), for: .normal)
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
    
    private func resetAllButtonBackGroundColor() {
        [button1, button2, button3, button4, button5].forEach { uv in
            uv.backgroundColor = .darkNavy
            uv.isSelected = false
        }
    }
    
    private func buttonToggle(_ button: UIButton) {
        resetAllButtonBackGroundColor()
        button.isSelected.toggle()
        button.backgroundColor = button.isSelected ? .midNavy : .darkNavy
    }
    
    private func bind() {
        button1.tapPublisher.sink {[unowned self] _ in
            self.actionSubject.send(.button1)
            self.buttonToggle(self.button1)
        }
        .store(in: &cancellables)

        button2.tapPublisher.sink {[unowned self] _ in
            self.actionSubject.send(.button2)
            self.buttonToggle(self.button2)
        }
        .store(in: &cancellables)

        button3.tapPublisher.sink {[unowned self] _ in
            self.actionSubject.send(.button3)
            self.buttonToggle(self.button3)
        }
        .store(in: &cancellables)
        
        button4.tapPublisher.sink {[unowned self] _ in
            self.actionSubject.send(.button4)
            self.buttonToggle(self.button4)
        }
        .store(in: &cancellables)
        
        button5.tapPublisher.sink {[unowned self] _ in
            self.actionSubject.send(.button5)
            self.buttonToggle(self.button5)
        }
        .store(in: &cancellables)

        nextButton
            .tapPublisher
            .sink {[unowned self] _ in
                UIView.transition(with: self.backgroundImageView,
                                  duration: 1,
                                  options: .curveEaseInOut,
                                  animations: nil,
                                  completion: nil)
                self.actionSubject.send(.next)
                self.resetAllButtonBackGroundColor()
            }
            .store(in: &cancellables)
    
    }
    
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
        
        [backgroundImageView, logoImageView, totalSv, nextButton].forEach { uv in
            addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backgroundImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            backgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            totalSv.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            totalSv.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),

            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -(UIScreen.main.height / 70)),
            
            logoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor ),
            logoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    public func setQuizData(_ data: Question) {
        questionLabel.text = data.title
        indexLabel.text = "\(data.surveyIdx)" + " / 6"
        button1.setTitle(data.option1, for: .normal)
        button2.setTitle(data.option2, for: .normal)
        button3.setTitle(data.option3, for: .normal)
        
        if data.option4 == nil {
            button4.isHidden = true
        } else {
            button4.isHidden = false
            button4.setTitle(data.option4, for: .normal)
        }
        
        if data.option5 == nil {
            button5.isHidden = true
        } else {
            button5.isHidden = false
            button5.setTitle(data.option5, for: .normal)
        }
    }
}
