//
//  MyCharacterView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//
import CombineCocoa
import Combine
import UIKit

enum MyCharacterViewAction: Actionable {
    case gear
    case dismiss
}

class MyCharacterView: BaseView<MyCharacterViewAction> {
    private(set) lazy var gearButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .gear, style: .done, target: nil, action: nil)
        return button
    }()
    private(set) var dismissButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return button
    }()
    private(set) lazy var tableView: UITableView = {
      let tableView = UITableView()
        tableView.register(
            MyCharacterViewTableViewHeaderCell.self,
            forHeaderFooterViewReuseIdentifier: MyCharacterViewTableViewHeaderCell.identifier
        )
        tableView.register(
            MyCharacterViewTableViewCell.self,
            forCellReuseIdentifier: MyCharacterViewTableViewCell.identifier
        )
        tableView.rowHeight = 90
        tableView.backgroundColor = .greyshWhite
        tableView.sectionHeaderTopPadding = 0
        tableView.isUserInteractionEnabled = false
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
    private func bind() {
        gearButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.sendAction(.gear)
            }
            .store(in: &cancellables)
        dismissButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.dismiss)
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
