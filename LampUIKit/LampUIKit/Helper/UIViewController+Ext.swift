//
//  UIViewController+Ext.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import Foundation

extension UIViewController {
    open func present(
        _ viewControllerToPresent: UIViewController,
        transitionType: CATransitionSubtype = .fromRight,
        animated flag: Bool,
        pushing: Bool,
        completion: (() -> Void)? = nil
    ) {
        if pushing {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = transitionType
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            viewControllerToPresent.modalPresentationStyle = .fullScreen
            self.present(viewControllerToPresent, animated: false, completion: completion)
        } else {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
}

extension UIViewController {
    func changeRoot(_ viewController: UIViewController) {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
    }
    
    func isInitialSettingDone(_ bool: Bool) {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.isInitialSettingDone = bool
    }
}
