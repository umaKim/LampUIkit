//
//  CreateNickNameView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//
import CombineCocoa
import Combine
import UIKit

enum CreateNickNameViewAction {
    case textFieldDidChange(String)
    case createAccountButtonDidTap
    case doneKeyboard
}

class CreateNickNameView: BaseView {

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<CreateNickNameViewAction, Never>()
    
    private let titleImage: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(named: "lampTitle")
        return uv
    }()
    
    private let nickNameTextField = LampRectangleTextField(placeholder: "닉네임을 정해주세요", placeHolderColor: .midNavy)
    
    private let createAccountButton = RectangleTextButton("계정 생성 완료하기", background: .systemGray, textColor: .white, fontSize: 17)
    
    override init() {
        self.isEnabledCreateAccountButton = false
        super.init()
        
        bind()
        setupUI()
    }
    
    private let toolBar = UIToolbar()
    private let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var isEnabledCreateAccountButton: Bool {
        didSet {
            self.createAccountButton.isEnabled = isEnabledCreateAccountButton
            self.createAccountButton.backgroundColor = self.createAccountButton.isEnabled ? .midNavy : .systemGray
        }
    }
    
    private func bind() {
        doneButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.actionSubject.send(.doneKeyboard)
            }
            .store(in: &cancellables)
        
        nickNameTextField
            .textPublisher
            .compactMap({$0})
            .sink {[weak self] text in
                guard let self = self else {return}
                self.actionSubject.send(.textFieldDidChange(text))
            }
            .store(in: &cancellables)
        
        createAccountButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.createAccountButtonDidTap)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        toolBar.items = [doneButton]
        toolBar.sizeToFit()
        nickNameTextField.inputAccessoryView = toolBar
        
        [titleImage, nickNameTextField, createAccountButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            
            nickNameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nickNameTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            nickNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nickNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 60),
            
            createAccountButton.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 64),
            createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createAccountButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            createAccountButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
