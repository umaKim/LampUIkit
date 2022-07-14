//
//  SearchViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import UIKit

class SearchViewController: UIViewController {

    private let contentView = SearchView()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
