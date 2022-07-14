//
//  LoginViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//

import UIKit

class LoginViewController: UIViewController {

    private let contentView = LoginView()
    private let viewModel: LoginViewModel
    
    init(vm: LoginViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
