//
//  StarRatingView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/01.
//

import AxisRatingBar
import SwiftUI

struct CustomRatingBar: View {
    
    private let axisMode: ARAxisMode
    private let interactionable: Bool
    
    init(axisMode: ARAxisMode, interactionable: Bool = true) {
        self.axisMode = axisMode
        self.interactionable = interactionable
    }
    
    @State private var starCount: CGFloat = 5
    @State private var innerRatio: CGFloat = 1
    @State private var spacing: CGFloat = 6
    @State private var fillMode: ARFillMode = .half
    
    @State private var value1: CGFloat = 1.50
    
    private var content: some View {
        let constant1 = ARConstant(rating: 5,
                                   size: CGSize(width: 36, height: 36),
                                   spacing: spacing,
                                   fillMode: fillMode,
                                   axisMode: axisMode,
                                   valueMode: .point,
                                   disabled: !interactionable)
        return
            Group {
                VStack {
                    AxisRatingBar(value: $value1, constant: constant1) {
                        ARStar(count: round(starCount), innerRatio: innerRatio)
                            .stroke()
                            .fill(Color.gray)
                    } foreground: {
                        ARStar(count: round(starCount), innerRatio: innerRatio)
                            .fill(Color.yellow)
                    }
                    
                    Text("\(value1, specifier: "%.2f")")
                        .foregroundColor(.black)
                }
            }
    }
    var body: some View {
        VStack {
            if axisMode == .horizontal {
                VStack(alignment: .center) {
                    content
                        .padding(.bottom)
                }
            }else {
                HStack(alignment: .bottom) {
                    content
                        .padding(.bottom)
                }
            }
        }
    }
}
