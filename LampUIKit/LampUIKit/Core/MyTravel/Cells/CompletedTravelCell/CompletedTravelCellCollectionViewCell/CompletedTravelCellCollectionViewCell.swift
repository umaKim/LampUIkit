//
//  CompletedTravelCellCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/05.
//
import Combine
import UIKit

protocol CompletedTravelCellCollectionViewCellDelegate: AnyObject {
    func completedTravelCellCollectionViewCellDidTapDelete(at index: Int)
}

final class CompletedTravelCellCollectionViewCell: UICollectionViewCell, BodyCellable {
    static let identifier = "CompletedTravelCellCollectionViewCell"
    private let containerView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 6
        uiView.layer.borderColor = UIColor.systemGray.cgColor
        uiView.backgroundColor = .greyshWhite
        uiView.clipsToBounds = true
        return uiView
    }()
    private let backgroundImageView: UIImageView = {
        let uiView = UIImageView()
        uiView.layer.cornerRadius = 6
        uiView.contentMode = .scaleAspectFill
        uiView.clipsToBounds = true
        uiView.image = .init(named: "BackgroundImagePlaceholder")
        return uiView
    }()
    private let filterImageView: UIImageView = {
        let uiView = UIImageView()
        uiView.layer.cornerRadius = 6
        uiView.backgroundColor = .black.withAlphaComponent(0.5)
        return uiView
    }()
    private let tickeBackgroundImageView: UIImageView = {
        let uiView = UIImageView()
        uiView.image = .init(named: "CompletedTicket")
        return uiView
    }()
    private lazy var visitiedDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    private lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(.xmarkWhite, for: .normal)
        return button
    }()
    private var cancellables: Set<AnyCancellable>
    weak var delegate: CompletedTravelCellCollectionViewCellDelegate?
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        configureShadow(0.4)
        bind()
        setupUI()
    }
    public func configure(_ model: MyCompletedTripLocation) {
        backgroundImageView.sd_setImage(
            with: URL(string: model.image),
            placeholderImage: .init(named: "BackgroundImagePlaceholder")
        )
        locationNameLabel.text = model.placeName
        addressLabel.text = model.placeAddress
        visitiedDateLabel.text = model.travelCompletedDate
    }
    private func bind() {
        deleteButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                HapticManager.shared.feedBack(with: .heavy)
                self.delegate?.completedTravelCellCollectionViewCellDidTapDelete(at: self.tag)
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        let totalSv = UIStackView(arrangedSubviews: [locationNameLabel, addressLabel])
        totalSv.axis = .vertical
        totalSv.distribution = .fillProportionally
        totalSv.alignment = .center
        totalSv.spacing = 8
        [
            containerView,
            backgroundImageView,
            filterImageView,
            tickeBackgroundImageView,
            totalSv,
            visitiedDateLabel,
            deleteButton
        ].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            filterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            filterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            filterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            filterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tickeBackgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            tickeBackgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tickeBackgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            tickeBackgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            totalSv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            totalSv.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            totalSv.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            visitiedDateLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            visitiedDateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
