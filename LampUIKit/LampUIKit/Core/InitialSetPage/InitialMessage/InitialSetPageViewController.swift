//
//  InitialSetPageViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//
import CombineCocoa
import Combine
import UIKit

class InitialSetPageViewController: BaseViewController<InitialSetPageView, InitialSetPageViewModel> {
    private lazy var beginningMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.alpha = 1
        label.numberOfLines = 4
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private lazy var darkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "darkCircle"))
        return imageView
    }()
    private lazy var twinkles: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "aroundTwinkles"))
        return imageView
    }()
    private var runCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkNavy
        isInitialSettingDone(false)
        animateBeginningMessageLabel()
        setupUI()
    }
    private func animateBeginningMessageLabel() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[weak self] timer in
            guard let self = self else {return}
            if self.runCount == 3 {
                timer.invalidate()
                let viewController = InitialQuizViewController(InitialQuizView(), InitialQuizViewModel())
                self.present(viewController, transitionType: .fromTop, animated: true, pushing: true)
            } else {
                UIView.transition(
                    with: self.beginningMessageLabel,
                    duration: 0.25,
                    options: .transitionFlipFromBottom
                ) { [weak self] in
                    self?.beginningMessageLabel.text = self?.viewModel.beginningMessage[self?.runCount ?? 0]
                }
            }
            self.runCount += 1
        }
    }
    private func setupUI() {
        //        [darkImageView, twinkles, beginningMessageLabel].forEach { uv in
        //            view.addSubview(uv)
        //            uv.translatesAutoresizingMaskIntoConstraints = false
        //        }
        view.addSubviews(darkImageView, twinkles, beginningMessageLabel)
        NSLayoutConstraint.activate([
            darkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            darkImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            twinkles.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            twinkles.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            beginningMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            beginningMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
    }
}
