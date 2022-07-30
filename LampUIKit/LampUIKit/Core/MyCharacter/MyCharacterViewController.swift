//
//  MyCharacterViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//

import UIKit

class MyCharacterViewController: BaseViewContronller {

    private let viewModel: MyCharacterViewModel
    
    init(vm: MyCharacterViewModel) {
        self.viewModel = vm
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
