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
        
        navigationItem.leftBarButtonItems = [contentView.backButton]
        
        bind()
        contentView.configure(with: viewModel.data)
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
                switch action {
                case .back:
                    HapticManager.shared.feedBack(with: .medium)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
