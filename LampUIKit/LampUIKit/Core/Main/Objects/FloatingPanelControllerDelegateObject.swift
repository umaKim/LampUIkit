//
//  FloatingPanelControllerDelegateObject.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/12/01.
//
import FloatingPanel
import UIKit

protocol FloatingPanelControllerDelegateProtocol: AnyObject {
    func endEditing(_ isTrue: Bool)
    func changeGoogleMapPadding()
}

final class FloatingPanelControllerDelegateObject: NSObject, FloatingPanelControllerDelegate {
    weak var delegate: FloatingPanelControllerDelegateProtocol?
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.state == .tip || fpc.state == .half {
            delegate?.endEditing(true)
        }
        delegate?.changeGoogleMapPadding()
    }
    func floatingPanel(
        _ viewController: FloatingPanelController,
        layoutFor newCollection: UITraitCollection
    ) -> FloatingPanelLayout {
        return FloatingPanelLampLayout()
    }
}
