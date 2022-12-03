//
//  MyPageView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import CombineCocoa
import Combine
import UIKit

enum MyPageViewAction: Actionable {
    case back
    case languageSelection
    case logoutActions
    case deleteAccountActions
}

class MyPageView: BaseView<MyPageViewAction> {
    private(set) lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return button
    }()
    private(set) lazy var socialLogin: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(), style: .done, target: nil, action: nil)
        button.isEnabled = false
        return button
    }()
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MyPageTableViewCell.self,
            forCellReuseIdentifier: MyPageTableViewCell.identifier
        )
        tableView.rowHeight = 72
        tableView.backgroundColor = .greyshWhite
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }()
    override init() {
        super.init()
        bind()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func presentLanguageSelection() {
        sendAction(.languageSelection)
    }
    public func presentLogOutActions() {
        sendAction(.logoutActions)
    }
    public func presentDeleteAccountActions() {
        sendAction(.deleteAccountActions)
    }
    public func setSocialLogin(_ provider: UserAuthType) {
        switch provider {
        case .apple:
            socialLogin.image = .appleLogo?.resize(to: 25, 30).withRenderingMode(.alwaysOriginal)
        case .google:
            socialLogin.image = .googleLogo?.resize(to: 30).withRenderingMode(.alwaysOriginal)
        case .kakao:
            socialLogin.image = .kakaoLogo?.resize(to: 30).withRenderingMode(.alwaysOriginal)
        case .firebase:
            socialLogin.image = .googleLogo?.resize(to: 30).withRenderingMode(.alwaysOriginal)
        }
    }
    private func bind() {
        backButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.sendAction(.back)
        }
        .store(in: &cancellables)
    }
    private func setupUI() {
        [tableView].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
