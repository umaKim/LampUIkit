//
//  InitialSetPageViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//
import CombineCocoa
import Combine
import UIKit

final class InitialSetPageViewController: BaseViewController<InitialSetPageView, InitialSetPageViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        isInitialSettingDone(false)
        contentView
            .animateBeginningMessageLabel(
                with: viewModel.beginningMessages
            ) {[weak self] in
                let viewController = InitialQuizViewController(InitialQuizView(), InitialQuizViewModel())
                self?.present(
                    viewController,
                    transitionType: .fromTop,
                    animated: true,
                    pushing: true
                )
            }
    }
}
