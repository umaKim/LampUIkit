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

class FloatingPanelControllerDelegateObject: NSObject, FloatingPanelControllerDelegate {
    weak var viewModel: FloatingPanelControllerDelegateProtocol?
    init(_ viewModel: FloatingPanelControllerDelegateProtocol?) {
        self.viewModel = viewModel
    }
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.state == .tip || fpc.state == .half {
//            view.endEditing(true)
            viewModel?.endEditing(true)
        }
//        setGMPadding()
        viewModel?.changeGoogleMapPadding()
    }
    func floatingPanel(
        _ viewController: FloatingPanelController,
        layoutFor newCollection: UITraitCollection
    ) -> FloatingPanelLayout {
        return FloatingPanelLampLayout()
    }
}
