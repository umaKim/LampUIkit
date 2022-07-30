//
//  MyCharacterView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//

import UIKit

class MyCharacterView: BaseWhiteView {

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
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

