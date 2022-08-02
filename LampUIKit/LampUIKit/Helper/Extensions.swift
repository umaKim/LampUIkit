//
//  Extensions.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/15.
//

import UIKit

extension UIScreen {
    var width: CGFloat {
        return bounds.width
    }
    
    var height: CGFloat {
        return bounds.height
    }
}

extension UIColor {
    static let midNavy = UIColor(red: 92/255, green: 92/255, blue: 141/255, alpha: 1)
    static let lightGrey = UIColor(red: 228/255, green: 228/255, blue: 232/255, alpha: 1)
    static let greyshWhite = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    static let darkNavy = UIColor(red: 38/255, green: 38/255, blue: 92/255, alpha: 1)
    static let lightNavy = UIColor(red: 112/255, green: 112/255, blue: 255/255, alpha: 1)
    static let whiteGrey = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
}

extension UIImage {
    static let camera = UIImage(named: "ARCamera")
    static let bell = UIImage(systemName: "bell")
    static let magnify = UIImage(systemName: "magnifyingglass")
    static let gear = UIImage(systemName: "gear")
}

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


extension UIButton {
    static func buttonMaker(
        image: UIImage?,
        placement: NSDirectionalRectEdge = .top,
        imagePadding: CGFloat,
        subTitle: String,
        subTitleSize: CGFloat = 14,
        subTitleColor: UIColor = .gray
    ) -> UIButton {
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = image
        configuration.imagePlacement = placement
        configuration.imagePadding = imagePadding
        configuration.subtitle = subTitle
        
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = subTitleColor
            outgoing.font = .robotoMedium(subTitleSize)
            return outgoing
        }
        
        configuration.subtitleTextAttributesTransformer = transformer
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        
        let bt = UIButton(configuration: configuration)
        return bt
    }
}

extension UIView {
    func configureShadow( _ shadowOpacity: Float = 0.2, _ shadowRadius: CGFloat = 7) {
        layer.masksToBounds = false
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = shadowRadius
    }
}

extension UINavigationController {
    func setTitleForgroundTitleColor(_ color: UIColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color]
    }

    func setLargeTitleColor(_ color: UIColor) {
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color]
    }

    func setAllTitleColor(_ color: UIColor) {
        setTitleForgroundTitleColor(color)
        setLargeTitleColor(color)
    }
}

extension UIFont {
    static func robotoLight(_ size: CGFloat) -> UIFont? {
        UIFont(name: "Roboto-Light", size: size)
    }
    
    static func robotoBold(_ size: CGFloat) -> UIFont? {
        UIFont(name: "Roboto-Bold", size: size)
    }
    
    static func robotoMedium(_ size: CGFloat) -> UIFont? {
        UIFont(name: "Roboto-Medium", size: size)
    }
    
    static func robotoRegular(_ size: CGFloat) -> UIFont? {
        UIFont(name: "Roboto-Rgular", size: size)
    }
}
