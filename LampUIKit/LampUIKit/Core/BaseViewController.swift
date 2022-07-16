//
//  BaseViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import UIKit

class BaseViewContronller: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .greyshWhite
        navigationController?.navigationBar.barTintColor = .greyshWhite
        navigationController?.navigationBar.isTranslucent = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseWhiteView: UIView {
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .greyshWhite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
