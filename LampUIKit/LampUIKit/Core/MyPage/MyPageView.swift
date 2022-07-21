//
//  MyPageView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import UIKit

class MyPageTableViewHeaderCell: UITableViewHeaderFooterView {
    static let identifier = "MyPageTableViewHeaderCell"
}

class MyPageTableViewCell: UITableViewCell {
    static let identifier = "MyPageTableViewCell"
}

class MyPageView: BaseWhiteView {

    private(set) lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.register(MyPageTableViewHeaderCell.self,
                    forHeaderFooterViewReuseIdentifier: MyPageTableViewHeaderCell.identifier)
        tv.register(MyPageTableViewCell.self,
                    forCellReuseIdentifier: MyPageTableViewCell.identifier)
        tv.rowHeight = 72
        return tv
    }()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
