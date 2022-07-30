//
//  SearchRecommendationCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import Combine
import CombineCocoa
import SDWebImage
import UIKit

protocol SearchRecommendationCollectionViewCellDelegate: AnyObject {
    func didTapMapPin()
    func didTapSetThisLocationButton()
}

class StarRatingView: UIView {
    
    private var star1ImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(systemName: "star")
        return uv
    }()
    
    private var star2ImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(systemName: "star")
        return uv
    }()
    
    private var star3ImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(systemName: "star")
        return uv
    }()
    
    private var star4ImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(systemName: "star")
        return uv
    }()
    
    private var star5ImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(systemName: "star")
        return uv
    }()
    
    init() {
        super.init(frame: .zero)
        
        let sv = UIStackView(arrangedSubviews: [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 1
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configure(with score: Int) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchRecommendationCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchRecommendationCollectionViewCell"
    
    weak var delegate: SearchRecommendationCollectionViewCellDelegate?
    
    private let titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        lb.textColor = .darkNavy
        lb.numberOfLines = 2
        return lb
    }()
    
    private let descriptionLabel: UILabel = {
       let lb = UILabel()
        lb.text = "서울특별시 종로구 사직로 161조선시대의 궁궐 중 하나이자  조선의 정궁, 법궁"
        lb.numberOfLines = 3
        lb.font = .systemFont(ofSize: 12)
        lb.textColor = .midNavy
        return lb
    }()
    
    private let starRatingView = StarRatingView()
    
    private let setThisLocationButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "destinationSetButton"), for: .normal)
        bt.layer.cornerRadius = 2.5
        bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return bt
    }()
    
    private let pinButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "openMapButton"), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bt.layer.cornerRadius = 2.5
        return bt
    }()
    
    private let locationImageView: UIImageView = {
        let uv = UIImageView()
        uv.image = .init(systemName: "house")
        uv.backgroundColor = .gray
        uv.layer.cornerRadius = 16
        uv.clipsToBounds = true
        uv.contentMode = .scaleAspectFill
        uv.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 2.2).isActive = true
        return uv
    }()
    
    private let favoriteButton: UIButton = {
       let bt = UIButton()
        let image = UIImage(named: "favorite_unselected")
        bt.setImage(image, for: .normal)
        return bt
    }()
    
    private let separatorView: UIView = {
       let uv = UIView()
        uv.backgroundColor = .lightGrey
        uv.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return uv
    }()
    
    private let lampSpotButton: UIButton = {
        let bt = UIButton()
        let image = UIImage(systemName: "circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        bt.setImage(image, for: .normal)
        return bt
    }()
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)

        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with location: LocationItem) {
        titleLabel.text = location.title
        
        guard let url = URL(string: location.firstimage) else {return}
        locationImageView.sd_setImage(with: url)
        
        starRatingView.configure(with: 3)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        locationImageView.image = nil
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        setThisLocationButton
            .tapPublisher
            .sink { _ in
                self.delegate?.didTapSetThisLocationButton()
            }
            .store(in: &cancellables)
        
        pinButton
            .tapPublisher
            .sink { _ in
                self.delegate?.didTapMapPin()
            }
            .store(in: &cancellables)
        
        favoriteButton
            .tapPublisher
            .sink { _ in
                
                self.isFavorite.toggle()
                
                if self.isFavorite {
                    self.favoriteButton.setImage(UIImage(named: "favorite_selected"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "favorite_unselected"), for: .normal)
                }
                self.delegate?.didTapFavoriteButton(at: self.tag,
                                                    self.isFavorite)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        
        backgroundColor = .greyshWhite
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, starRatingView])
        labelStackView.axis = .vertical
        labelStackView.spacing = 9
        labelStackView.alignment = .fill
        labelStackView.distribution = .fill
        
        let buttonStackView = UIStackView(arrangedSubviews: [setThisLocationButton, pinButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 9
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fill
        
        let halfStackView = UIStackView(arrangedSubviews: [labelStackView, buttonStackView])
        halfStackView.axis = .vertical
        halfStackView.spacing = 9
        halfStackView.alignment = .fill
        halfStackView.distribution = .fill
        
        let totalStackView = UIStackView(arrangedSubviews: [halfStackView, locationImageView])
        totalStackView.axis = .horizontal
        totalStackView.spacing = 16
        totalStackView.alignment = .fill
        totalStackView.distribution = .fill
        
        [totalStackView, favoriteButton, separatorView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: locationImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: -8),
            
            separatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
