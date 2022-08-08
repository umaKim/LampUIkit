//
//  MapViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//

import UIKit

class MapViewController: BaseViewContronller  {

    private let contentView: MapView = MapView()
    
    init(_ vm: MapViewModel) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    */

}
