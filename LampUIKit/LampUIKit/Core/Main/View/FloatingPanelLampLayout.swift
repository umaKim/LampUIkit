//
//  FloatingPanelLampLayout.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/25.
//
import FloatingPanel
import UIKit

class FloatingPanelLampLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 12, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 302.0, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 65.0, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.0
    }
}
