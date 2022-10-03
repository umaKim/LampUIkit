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
        let bt = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.register(MyPageTableViewCell.self,
                    forCellReuseIdentifier: MyPageTableViewCell.identifier)
        tv.rowHeight = 72
        tv.backgroundColor = .greyshWhite
        tv.sectionHeaderTopPadding = 0
        return tv
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
    
    private func bind() {
        backButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.sendAction(.back)
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        [tableView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
