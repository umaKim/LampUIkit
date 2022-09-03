//
//  InitialSetPageViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//
import CombineCocoa
import Combine
import UIKit

class InitialSetPageViewController: BaseViewContronller {

    private lazy var beginningMessageLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .greyshWhite
        lb.numberOfLines = 4
        lb.textAlignment = .center
//        lb.font = .robotoBold(20)
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        return lb
    }()
    
    private lazy var darkImageView: UIImageView = {
       let uv = UIImageView(image: UIImage(named: "darkCircle"))
        return uv
    }()
    
    private lazy var twinkles: UIImageView = {
        let uv = UIImageView(image: UIImage(named: "aroundTwinkles"))
         return uv
    }()
    
    private let viewModel: InitialSetPageViewModel
    
    init(vm: InitialSetPageViewModel) {
        self.viewModel = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                let vc = InitialQuizViewController(vm: InitialQuizViewModel())
                self.present(vc, transitionType: .fromTop, animated: true, pushing: true)
                
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
        
        [beginningMessageLabel, darkImageView, twinkles].forEach { uv in
            view.addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
