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
import SwiftUI

protocol SearchRecommendationCollectionViewCellDelegate: AnyObject {
    func didTapMapPin(location: RecommendedLocation)
    func didTapSetThisLocationButton(at index: Int, _ location: RecommendedLocation)
    //    func didTapCancelThisLocationButton(at index: Int, _ location: RecommendedLocation)
    func didTapFavoriteButton(at index: Int, _ location: RecommendedLocation)
}

class SearchRecommendationCollectionViewCell: UICollectionViewCell, BodyCellable {
    static let identifier = "SearchRecommendationCollectionViewCell"
    weak var delegate: SearchRecommendationCollectionViewCellDelegate?
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .darkNavy
        lb.numberOfLines = 2
        return lb
    }()
    private let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 3
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .midNavy
        return lb
    }()
    private var starDelegate: ContentViewDelegate = ContentViewDelegate()
    private lazy var starRatingImageView = UIImageView()
    private let setThisLocationButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "destinationSetButtonKr".localized), for: .normal)
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
        uv.layer.cornerRadius = 8
        uv.clipsToBounds = true
        uv.contentMode = .scaleAspectFill
        uv.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 2.4).isActive = true
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
    private var location: RecommendedLocation?
    private var isFavorite: Bool = false
    private var isOnPlan: Bool = false
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        bind()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with location: RecommendedLocation) {
        self.location = location
        titleLabel.text = location.title
        if location.image == "" {
            locationImageView.image = .placeholder
        }
        locationImageView.sd_setImage(with: URL(string: location.image ?? ""), placeholderImage: .placeholder)
        isFavorite = location.isBookMarked
        favoriteButton.setImage(
            UIImage(named: isFavorite ? "favorite_selected" : "favorite_unselected"),
            for: .normal
        )
        let starRating = Double(location.rate ?? 0)
        starDelegate.starValue = CGFloat(starRating)
        descriptionLabel.text = location.addr
        starRatingImageView.image = UIImage(named: "small\(location.rate ?? 0)")
        self.isOnPlan = location.isOnPlan ?? false
        setThisLocationButton.setImage(
            UIImage(named: isOnPlan ? "destinationCancelButtonKr".localized : "destinationSetButtonKr".localized),
            for: .normal
        )
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        locationImageView.image = nil
        setThisLocationButton.setImage(nil, for: .normal)
        favoriteButton.setImage(nil, for: .normal)
    }
    private var cancellables: Set<AnyCancellable>
    private func bind() {
        setThisLocationButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                HapticManager.shared.feedBack(with: .medium)
                self.isOnPlan.toggle()
                self.setThisLocationButton.setImage(
                    UIImage(named: self.isOnPlan ? "destinationCancelButtonKr".localized : "destinationSetButtonKr".localized),
                    for: .normal
                )
                if let location = self.location {
                    self.delegate?.didTapSetThisLocationButton(at: self.tag, location)
                }
            }
            .store(in: &cancellables)
        pinButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                HapticManager.shared.feedBack(with: .medium)
                if let location = self.location {
                    self.delegate?.didTapMapPin(location: location)
                }
            }
            .store(in: &cancellables)
        favoriteButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                HapticManager.shared.feedBack(with: .medium)
                self.isFavorite.toggle()
                self.favoriteButton.setImage(
                    UIImage(named: self.isFavorite ? "favorite_selected" : "favorite_unselected"),
                    for: .normal
                )
                if let location = self.location {
                    self.delegate?.didTapFavoriteButton(at: self.tag,
                                                        location)
                }
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        backgroundColor = .greyshWhite
        let descriptionSv = UIStackView(arrangedSubviews: [descriptionLabel])
        descriptionSv.axis = .horizontal
        descriptionSv.alignment = .top
        descriptionSv.distribution = .fill
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionSv, starRatingImageView])
        labelStackView.axis = .vertical
        labelStackView.spacing = 9
        labelStackView.alignment = .leading
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
        totalStackView.spacing = 19
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
