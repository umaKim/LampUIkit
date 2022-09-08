//
//  UIButton+Ext.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/15.
//

import UIKit

extension UIButton {
    static func buttonMaker(
        image: UIImage?,
        placement: NSDirectionalRectEdge = .top,
        imagePadding: CGFloat,
        subTitle: String,
        subTitleSize: CGFloat = 12,
        subTitleColor: UIColor = .gray
    ) -> UIButton {
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = image
        configuration.imagePlacement = placement
        configuration.imagePadding = imagePadding
        configuration.subtitle = subTitle
        configuration.activityIndicatorColorTransformer = .init({ color in .darkNavy
        })
        
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = subTitleColor
            outgoing.font = .systemFont(ofSize: 14, weight: .semibold)
            return outgoing
        }
        
        configuration.subtitleTextAttributesTransformer = transformer
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        
        let bt = UIButton(configuration: configuration)
        return bt
    }
}

extension UIButton {
    func showLoading() {
        configuration?.showsActivityIndicator = true
    }
    
    func hideLoading() {
        configuration?.showsActivityIndicator = false
    }
}
