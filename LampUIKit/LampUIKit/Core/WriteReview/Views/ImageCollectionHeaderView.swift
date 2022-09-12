//
//  ImageCollectionHeaderView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/15.
//
import CombineCocoa
import Combine
import UIKit

protocol ImageCollectionHeaderViewDelegate: AnyObject {
    func imageCollectionHeaderViewDidTapAdd()
}

class ImageCollectionHeaderView: UICollectionReusableView {
    static let identifier = "ImageCollectionHeaderView"
    
    weak var delegate: ImageCollectionHeaderViewDelegate?
    
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
        super.init(frame: frame)
        
        button.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
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
