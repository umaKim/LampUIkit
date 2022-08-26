//
//  UIViewController+Ext.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import UIKit

extension UIViewController {
    open func present(
        _ viewControllerToPresent: UIViewController,
        transitionType: CATransitionSubtype = .fromRight,
        presentationStyle: UIModalPresentationStyle = .fullScreen,
        animated flag: Bool,
        pushing: Bool,
        completion: (() -> Void)? = nil
    ) {
        if pushing {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .push
            transition.subtype = transitionType
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            viewControllerToPresent.modalPresentationStyle = presentationStyle
            self.present(viewControllerToPresent, animated: false, completion: completion)
        } else {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    func presentWithNav(
        _ vc: UIViewController,
        _ modalPresentationStyle: UIModalPresentationStyle = .automatic
    ) {
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = modalPresentationStyle
        self.present(nav, animated: true)
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

fileprivate var containerView: UIView?

extension UIViewController {
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView ?? UIView())
        
        containerView?.backgroundColor = .systemBackground
        containerView?.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {containerView?.alpha = 0.8})
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        containerView?.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
}

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
