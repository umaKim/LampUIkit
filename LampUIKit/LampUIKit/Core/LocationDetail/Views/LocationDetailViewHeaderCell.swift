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
    func locationDetailViewHeaderCellDidTapAddToMyTrip()
    func locationDetailViewHeaderCellDidTapRemoveFromMyTrip()
}

class LocationDescriptionView: UIView {
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .midNavy
        lb.font = .robotoMedium(14)
        lb.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return lb
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        lb.textAlignment = .left
        lb.font = .robotoMedium(14)
        return lb
    }()
    
    init(_ title: String, description: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .top
        sv.spacing = 16
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

class LocationDetailViewHeaderCell: UICollectionReusableView {
    
    static let identifier = "LocationDetailViewHeaderCell"
    
    private lazy var locationImageView: UIImageView = {
        let uv = UIImageView()
        uv.image = UIImage(systemName: "person")
        uv.backgroundColor = .midNavy
        uv.layer.cornerRadius = 6
        uv.clipsToBounds = true
        return uv
    }()
    
    private let buttonSv = LocationDetailViewHeaderCellButtonStackView()
    
    private let dividerView = DividerView()
    
    private let timeLabel: LocationDescriptionView = {
        let uv = LocationDescriptionView("관람시간", description: "09:00~18:30 (입장마감은 17:30)")
        uv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return uv
    }()
    
    private let priceLabel: LocationDescriptionView = {
        let uv = LocationDescriptionView("관람요금",
                                         description: "성인 : 3,000원 (개인) |  2,400원 (단체) \n만 65세 이상 / 만 6세 이하  : 무료\n소인 : 1,500원 (개인) | 1,200원 (단체)")
        uv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return uv
    }()
    
    private lazy var addToMyTravelButton = RectangleTextButton("내 여행지로 추가", background: .midNavy, textColor: .white, fontSize: 17)
    
    weak var delegate: LocationDetailViewHeaderCellDelegate?
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        bind()
        setupUI()
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        buttonSv
            .actionPublisher
            .sink { action in
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
        
        addToMyTravelButton
            .tapPublisher
            .sink { _ in
                self.addToMyTravelButton.isSelected.toggle()
                
                if self.addToMyTravelButton.isSelected {
                    self.addToMyTravelButton.update("내여행지로 추가 취소", background: .systemGray, textColor: .white)
                    self.delegate?.locationDetailViewHeaderCellDidTapAddToMyTrip()
                } else {
                    self.addToMyTravelButton.update("내여행지로 추가", background: .midNavy, textColor: .white)
                    self.delegate?.locationDetailViewHeaderCellDidTapRemoveFromMyTrip()
                }
            }
            .store(in: &cancellables)
    }
extension LocationDetailViewHeaderCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.width-32,
                     height: UIScreen.main.width-32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
    private func setupUI() {
        let labelStackView = UIStackView(arrangedSubviews: [timeLabel, priceLabel])
        labelStackView.alignment = .leading
        labelStackView.distribution = .fill
        labelStackView.spacing = 16
        labelStackView.axis = .vertical
        
        [locationImageView, buttonSv, dividerView, labelStackView, addToMyTravelButton].forEach { uv in
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
            
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            
            addToMyTravelButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            addToMyTravelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addToMyTravelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addToMyTravelButton.heightAnchor.constraint(equalToConstant: 60),
            addToMyTravelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

