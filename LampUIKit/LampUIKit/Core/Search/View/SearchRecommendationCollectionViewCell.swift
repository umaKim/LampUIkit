//
//  SearchRecommendationCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//
import HapticManager
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

final class SearchRecommendationCollectionViewCell: UICollectionViewCell, BodyCellable {
    static let identifier = "SearchRecommendationCollectionViewCell"
    weak var delegate: SearchRecommendationCollectionViewCellDelegate?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .darkNavy
        label.numberOfLines = 2
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .midNavy
        return label
    }()
    private var starDelegate: ContentViewDelegate = ContentViewDelegate()
    private lazy var starRatingImageView = UIImageView()
    private let setThisLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "destinationSetButtonKr".localized), for: .normal)
        button.layer.cornerRadius = 2.5
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    private let pinButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "openMapButton"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 2.5
        return button
    }()
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.width / 2.4).isActive = true
        return imageView
    }()
    private let favoriteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "favorite_unselected")
        button.setImage(image, for: .normal)
        return button
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
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
            UIImage(
                named: isFavorite ? "favorite_selected" : "favorite_unselected"),
            for: .normal
        )
        let starRating = Double(location.rate ?? 0)
        starDelegate.starValue = CGFloat(starRating)
        descriptionLabel.text = location.addr
        starRatingImageView.image = UIImage(named: "small\(location.rate ?? 0)")
        self.isOnPlan = location.isOnPlan ?? false
        setThisLocationButton.setImage(
            UIImage(
                named: isOnPlan ? "destinationCancelButtonKr".localized : "destinationSetButtonKr".localized
            ),
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
                    UIImage(
                        named: self.isOnPlan ? "destinationCancelButtonKr".localized : "destinationSetButtonKr".localized
                    ),
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
                    UIImage(
                        named: self.isFavorite ? "favorite_selected" : "favorite_unselected"
                    ),
                    for: .normal
                )
                if let location = self.location {
                    self.delegate?.didTapFavoriteButton(
                        at: self.tag,
                        location
                    )
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Set up UI
extension SearchRecommendationCollectionViewCell {
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
        addSubviews(totalStackView, favoriteButton, separatorView)
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
