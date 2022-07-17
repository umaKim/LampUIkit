//
//  MainTabBarViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    private let uid: String
    
    init(with uid: String) {
        self.uid = uid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: LampSpotViewController(vm: LampSpotViewModel()),
                                title: "램프스팟",
                                imageName: "house"),
            
            createNavController(viewController: SearchViewController(vm: SearchViewModel()),
                                title: "검색",
                                imageName: "apps"),
            
            createNavController(viewController: MyTravelViewController(vm: MyTravelViewModel()),
                                title: "나의여행",
                                imageName: "search"),
            
            createNavController(viewController: UIViewController(),
                                title: "마이캐릭터",
                                imageName: "music"),
        ]
        
        tabBar.barTintColor = .greyshWhite
        tabBar.backgroundColor = .greyshWhite
    }
    
    fileprivate func createNavController(
        viewController: UIViewController,
        title: String,
        imageName: String
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
