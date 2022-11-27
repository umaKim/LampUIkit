//
//  SceneDelegate.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//
import KakaoSDKUser
import FirebaseAuth
import KakaoSDKAuth
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        configureLanguage()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = StartPageViewController(StartPageView(), StartPageViewModel())
        window?.backgroundColor = .black
        window?.backgroundColor = .greyshWhite
        window?.makeKeyAndVisible()
    }
    
    private func configureLanguage() {
        let languageId = Locale.preferredLanguages[0].components(separatedBy: "-")[0]
        if languageId == "ko" {
            LanguageManager.shared.setLanguage(.korean)
        } else if languageId == "ja" {
            LanguageManager.shared.setLanguage(.japanese)
        } else {
            LanguageManager.shared.setLanguage(.enghlish)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        guard let isInitialSettingDone = isInitialSettingDone else { return }
        
        if !isInitialSettingDone {
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
            }
            
            do {
               try Auth.auth().signOut()
            } catch {
                print(error)
            }
        }
    }
    
    var isInitialSettingDone: Bool?

    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
        window.rootViewController = vc
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromBottom],
                          animations: nil,
                          completion: nil)
    }
}
