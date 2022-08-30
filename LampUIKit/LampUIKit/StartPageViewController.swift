//
//  StartPageViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//
import KakaoSDKUser
import KakaoSDKAuth
import Firebase
import Combine
import CombineCocoa
import UIKit
import Lottie

class StartPageViewController: UIViewController {

    private lazy var background: UIImageView = {
        let uv = UIImageView()
        uv.image = UIImage(named: "startImage")
        return uv
    }()
    
    private lazy var animaionView = AnimationView(name: "TwinkleAnimation")
    
    private lazy var titleImage: UIImageView = {
        let uv = UIImageView()
        uv.image = UIImage(named: "lampTitle")
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
    
    private func presentMain(with uid: String) {
        NetworkService.shared.setToken(uid)
        present(UINavigationController(rootViewController:  MainViewController(MainViewModel())),
                transitionType: .fromTop,
                animated: true, pushing: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserApi.shared.logout { error in
//            print(error)
//        }
        
        startButton.tapPublisher.sink {[unowned self] _ in
            HapticManager.shared.feedBack(with: .heavy)
            if AuthApi.hasToken() {
                UserApi.shared.me {[unowned self] user, error in
                    guard let id = user?.id else { return }
                    NetworkService.shared.setUserAuthType(.kakao)
                    self.presentMain(with: "\(id)")
                }
            }
            else if let uid = Auth.auth().currentUser?.uid {
                NetworkService.shared.setUserAuthType(.firebase)
                self.presentMain(with: uid)
            } else {
                self.present(LoginViewController(vm: LoginViewModel()),
                             transitionType: .fromTop,
                             animated: true,
                             pushing: true)
            }
        }
        .store(in: &cancellables)
        
        animaionView.loopMode = .loop
        animaionView.play()
        
        view.addSubview(animaionView)
        
        animaionView.frame = view.bounds
        
        [background, titleImage, startButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.topAnchor.constraint(equalTo: view.topAnchor),
            
            titleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
