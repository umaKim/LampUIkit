//
//  StartPageViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//
import Firebase
import Combine
import CombineCocoa
import UIKit

class StartPageViewController: UIViewController {

    private lazy var background: UIImageView = {
        let uv = UIImageView()
        uv.image = UIImage(named: "startImage")
        return uv
    }()
    
    private lazy var startButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "startButton"), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 62).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 62).isActive = true
        return bt
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.tapPublisher.sink { _ in
            if let uid = Auth.auth().currentUser?.uid {
                self.present(MainTabBarViewController(with: uid), transitionType: .fromTop, animated: true, pushing: true)
            } else {
                self.present(LoginViewController(vm: LoginViewModel()), transitionType: .fromTop, animated: true, pushing: true)
            }
        }
        .store(in: &cancellables)
        
        [background, startButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.topAnchor.constraint(equalTo: view.topAnchor),
            
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
