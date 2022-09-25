//
//  BaseViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//
import Combine
import UIKit

class BaseViewController<CV, VM>: UIViewController {
    var cancellables: Set<AnyCancellable>
    
    let contentView: CV
    let viewModel: VM
    
    init(
        _ cv: CV,
        _ vm: VM
    ) {
        self.contentView = cv
        self.viewModel = vm
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView as? UIView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
