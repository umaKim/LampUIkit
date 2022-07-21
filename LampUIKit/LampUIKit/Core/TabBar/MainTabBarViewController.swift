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
                                imageName: "lampSpot_unselected",
                                selectedImage: "lampSpot_selected"),
            
            createNavController(viewController: SearchViewController(vm: SearchViewModel()),
                                title: "검색",
                                imageName: "search_unselected",
                                selectedImage: "search_selected"),
            
            createNavController(viewController: MyTravelViewController(vm: MyTravelViewModel()),
                                title: "나의여행",
                                imageName: "myTravel_unselected",
                                selectedImage: "myTravel_selected"),
            
            createNavController(viewController: UIViewController(),
                                title: "마이캐릭터",
                                imageName: "myCharacter_unselected",
                                selectedImage: "myCharacter_selected"),
        ]
        
        tabBar.barTintColor = .greyshWhite
        tabBar.tintColor = .midNavy
        tabBar.backgroundColor = .greyshWhite
    }
    
    fileprivate func createNavController(
        viewController: UIViewController,
        title: String,
        imageName: String,
        selectedImage: String
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
//        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = .init(named: imageName)
        navController.tabBarItem.selectedImage = .init(named: selectedImage)?.withTintColor(.midNavy, renderingMode: .alwaysOriginal)
        navController.setAllTitleColor(.midNavy)
        return navController
    }
}
