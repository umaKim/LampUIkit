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
        
        UIView.animate(withDuration: 0.25, animations: {containerView?.alpha = 0.5})
        
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

fileprivate var emptyStateView: EmptyStateView?

extension UIView {
    func showEmptyStateView(with message: String) {
        let emptyStateView = EmptyStateView(message: message)
        
        addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        emptyStateView = EmptyStateView(message: message)
        
        guard let emptyStateView = emptyStateView else {return}
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func restoreViews() {
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
    
    func showEmptyStateView(on view: UIView, when isState: Bool, with message: String) {
        if isState {
            self.showEmptyStateView(with: message, in: view)
        } else {
            self.restoreViews()
        }
    }
}
