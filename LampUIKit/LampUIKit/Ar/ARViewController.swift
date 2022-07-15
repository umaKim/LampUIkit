//
//  ARViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/15.
//

import UIKit

class ARViewModel {
    
}

class ARViewController: UIViewController {

    private let viewModel: ARViewModel
    
    init(vm: ARViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
}
