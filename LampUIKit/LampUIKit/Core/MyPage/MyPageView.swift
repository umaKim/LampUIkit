//
//  MyPageView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import CombineCocoa
import Combine
import UIKit

class MyPageTableViewHeaderCell: UITableViewHeaderFooterView {
    static let identifier = "MyPageTableViewHeaderCell"
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        return lb
    }()
    
    private lazy var emailLabel: UILabel = {
       let lb = UILabel()
        return lb
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyPageTableViewCell: UITableViewCell {
    static let identifier = "MyPageTableViewCell"
    
    private let titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "label"
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 16, weight: .semibold)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .greyshWhite
        
        [titleLabel].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with title: String) {
        self.titleLabel.text = title
    }
}

enum MyPageViewAction {
    case back
    case logoutActions
    case deleteAccountActions
}

class MyPageView: BaseWhiteView {
    private(set) lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named:"back")?.withTintColor(.midNavy, renderingMode: .alwaysOriginal)
        let bt = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MyPageViewAction, Never>()
    
    private(set) lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.register(MyPageTableViewHeaderCell.self,
                    forHeaderFooterViewReuseIdentifier: MyPageTableViewHeaderCell.identifier)
        tv.register(MyPageTableViewCell.self,
                    forCellReuseIdentifier: MyPageTableViewCell.identifier)
        tv.rowHeight = 72
        tv.backgroundColor = .greyshWhite
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
    
    public func presentLogOutActions() {
        self.actionSubject.send(.logoutActions)
    }
    
    public func presentDeleteAccountActions() {
        self.actionSubject.send(.deleteAccountActions)
    }
    
    private func bind() {
        backButton.tapPublisher.sink { _ in
            self.actionSubject.send(.back)
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
