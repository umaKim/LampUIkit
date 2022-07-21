//
//  MyPageViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import UIKit

class MyPageViewController: BaseViewContronller {

    private let contentView = MyPageView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    private let viewModel: MyPageViewModel
    
    init(vm: MyPageViewModel) {
        self.viewModel = vm
        super.init()
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier,
                                                     for: indexPath) as? MyPageTableViewCell
        else {return UITableViewCell()}
        return cell
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
