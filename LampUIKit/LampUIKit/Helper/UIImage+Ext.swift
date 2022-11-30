//
//  UIImage+Ext.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//
import UIKit
import Foundation

extension UIImage {
    static let camera = UIImage(named: "ARCamera")
    static let bell = UIImage(systemName: "bell")
    static let magnify = UIImage(systemName: "magnifyingglass")
    static let gear = UIImage(named: "setting")?.withTintColor(.midNavy, renderingMode: .alwaysOriginal)
    static let xmark = UIImage(systemName: "xmark")?.withTintColor(.midNavy, renderingMode: .alwaysOriginal)
    static let xmarkWhite = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    static let back = UIImage(named: "back")?.withTintColor(.midNavy, renderingMode: .alwaysOriginal)
    static let placeholder = UIImage(named: "placeholder".localized) ?? .init(systemName: "house")
    static let circleRecommended = UIImage(named: "circleRecommended")
    static let circleDestination = UIImage(named: "circleDestination")
    static let circleCompleted = UIImage(named: "circleCompleted")
    static let appleLogo = UIImage(named: "appleLogo")
    static let googleLogo = UIImage(named: "googleLogo")
    static let kakaoLogo = UIImage(named: "kakaoLogo")
}

extension UIImage {
    func resize(to newWidth: CGFloat) -> UIImage {
        let newHeight = newWidth
        return renderImage(newWidth: newWidth, newHeight: newHeight)
    }
    func resize(to newWidth: CGFloat, _ newHeight: CGFloat) -> UIImage {
        return renderImage(newWidth: newWidth, newHeight: newHeight)
    }
    private func renderImage(newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
}

extension UIImage {
    // image with rounded corners
    public func withRoundedCorners(_ radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius,
           radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    var isPortrait: Bool { size.height > size.width }
    var isLandscape: Bool { size.width > size.height }
    var breadth: CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect { .init(origin: .zero, size: breadthSize) }
    func rounded(with color: UIColor, width: CGFloat) -> UIImage? {
        guard
            let cgImage = cgImage?.cropping(to:
                    .init(origin:
                            .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : .zero,
                                  y: isPortrait ? ((size.height-size.width)/2).rounded(.down) : .zero),
                          size: breadthSize))
        else { return nil }
        let bleed = breadthRect.insetBy(dx: -width, dy: -width)
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: bleed.size, format: format).image { context in
            UIBezierPath(ovalIn: .init(origin: .zero, size: bleed.size)).addClip()
            var strokeRect =  breadthRect.insetBy(dx: -width/2, dy: -width/2)
            strokeRect.origin = .init(x: width/2, y: width/2)
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
                .draw(in: strokeRect.insetBy(dx: width/2, dy: width/2))
            context.cgContext.setStrokeColor(color.cgColor)
            let line: UIBezierPath = .init(ovalIn: strokeRect)
            line.lineWidth = width
            line.stroke()
        }
    }
}
