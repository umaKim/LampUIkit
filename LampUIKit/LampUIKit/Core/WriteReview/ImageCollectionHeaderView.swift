//
//  ImageCollectionHeaderView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/15.
//
import CombineCocoa
import Combine
import UIKit

class ImageCollectionHeaderView: UICollectionReusableView {
    private lazy var button: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "newImageButton"), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 84).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 84).isActive = true
        return bt
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        cancellables = .init()
        
        button.tapPublisher.sink { _ in
            self.delegate?.imageCollectionHeaderViewDidTapAdd()
        }
        .store(in: &cancellables)
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
