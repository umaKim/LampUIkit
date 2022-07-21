//
//  LocationDetailViewHeaderCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import Combine
import UIKit

protocol LocationDetailViewHeaderCellDelegate: AnyObject {
    func locationDetailViewHeaderCellDidTapSave()
    func locationDetailViewHeaderCellDidTapReview()
    func locationDetailViewHeaderCellDidTapAr()
    func locationDetailViewHeaderCellDidTapShare()
}

class LocationDetailViewHeaderCell: UICollectionReusableView {
    
    static let identifier = "LocationDetailViewHeaderCell"
    
    private lazy var locationImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(systemName: "person")
        uv.backgroundColor = .systemOrange
        return uv
    }()
    
    private let buttonSv = LocationDetailViewHeaderCellButtonStackView()
    
    private let dividerView = DividerView()
    
    private let addToMyTravelButton = RectangleTextButton("내 여행지로 추가", background: .midNavy, textColor: .white, fontSize: 17)
    
    weak var delegate: LocationDetailViewHeaderCellDelegate?
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        bind()
        setupUI()
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        buttonSv.actionPublisher.sink { action in
            switch action {
            case .save:
                self.delegate?.locationDetailViewHeaderCellDidTapSave()
                
            case .ar:
                self.delegate?.locationDetailViewHeaderCellDidTapAr()
                
            case .review:
                self.delegate?.locationDetailViewHeaderCellDidTapReview()
                
            case .share:
                self.delegate?.locationDetailViewHeaderCellDidTapShare()
            }
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        [locationImageView, buttonSv, dividerView, addToMyTravelButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            locationImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
            locationImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
            
            buttonSv.topAnchor.constraint(equalTo: locationImageView.bottomAnchor),
            buttonSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonSv.heightAnchor.constraint(equalToConstant: 95),
            
            dividerView.topAnchor.constraint(equalTo: buttonSv.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            addToMyTravelButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            addToMyTravelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addToMyTravelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addToMyTravelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

