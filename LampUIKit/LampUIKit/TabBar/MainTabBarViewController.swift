//
//  MainTabBarViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: LampSpotViewController(vm: LampSpotViewModel()),
                                title: "Today",
                                imageName: "today_icon"),
            
            createNavController(viewController: UIViewController(),
                                title: "Apps",
                                imageName: "apps"),
            
            createNavController(viewController: UIViewController(),
                                title: "Search",
                                imageName: "search"),
            
            createNavController(viewController: UIViewController(),
                                title: "Music",
                                imageName: "music"),
        ]
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
