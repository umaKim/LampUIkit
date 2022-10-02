//
//  ReviewDetailViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/05.
//

import UIKit

class ReviewDetailViewController: BaseViewController<ReviewDetailView, ReviewDetailViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.configure(with: viewModel.data)
    }
}
