//
//  MyCharacterView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//
import CombineCocoa
import Combine
import UIKit

enum MyCharacterViewAction {
    case gear
    case dismiss
}

class MyCharacterView: BaseWhiteView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MyCharacterViewAction, Never>()

    private(set) lazy var gearButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: nil, action: nil)
        bt.tintColor = .black
        return bt
    }()
    
    private(set) var dismissButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var tableView: UITableView = {
      let tv = UITableView()
        tv.register(MyCharacterViewTableViewHeaderCell.self, forHeaderFooterViewReuseIdentifier: MyCharacterViewTableViewHeaderCell.identifier)
        tv.register(MyCharacterViewTableViewCell.self, forCellReuseIdentifier: MyCharacterViewTableViewCell.identifier)
        tv.rowHeight = 90
        tv.backgroundColor = .greyshWhite
        tv.sectionHeaderTopPadding = 0
        tv.isUserInteractionEnabled = false
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
    
    private func bind() {
        gearButton.tapPublisher.sink { _ in
            self.actionSubject.send(.gear)
        }
        .store(in: &cancellables)
        
        dismissButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.dismiss)
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

