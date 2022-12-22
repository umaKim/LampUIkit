//
//  File.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/28.
//
import HapticManager
import Combine
import UIKit

protocol MyTravelCellCollectionViewCellDelegate: AnyObject {
    func myTravelCellCollectionViewCellDidTapDelete(at index: Int)
    func myTravelCellCollectionViewCellDidTapComplete(at index: Int)
}

final class MyTravelCellCollectionViewCell: UICollectionViewCell, BodyCellable {
    static let identifier = "MyTravelCellCollectionViewCell"
    weak var delegate: MyTravelCellCollectionViewCellDelegate?
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.backgroundColor = .greyshWhite
        view.clipsToBounds = true
        return view
    }()
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = .init(named: "BackgroundImagePlaceholder")
        return imageView
    }()
    private let filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .black.withAlphaComponent(0.4)
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "경복궁"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "removeTrip".localized), for: .normal)
        button.isHidden = true
        return button
    }()
    private lazy var completeTripButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "completeTrip".localized), for: .normal)
        button.isHidden = false
        return button
    }()
    private var cancellables: Set<AnyCancellable>
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        configureShadow(0.4)
        bind()
        setupUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
        titleLabel.text = nil
        addressLabel.text = nil
    }
    public func configure(_ location: MyTravelLocation) {
        backgroundImageView.sd_setImage(
            with: URL(string: location.image ?? ""),
            placeholderImage: .init(named: "BackgroundImagePlaceholder")
        )
        titleLabel.text = location.placeName
        addressLabel.text = location.placeAddress
    }
    var showDeleButton: Bool? {
        didSet {
            deleteButton.isHidden = !(showDeleButton ?? false)
            completeTripButton.isHidden = showDeleButton ?? true
        }
    }
    public func bind() {
        deleteButton
            .tapPublisher
            .sink {[weak self] _ in
                HapticManager.shared.feedBack(with: .medium)
                guard let self = self else {return }
                self.delegate?.myTravelCellCollectionViewCellDidTapDelete(at: self.tag)
            }
            .store(in: &cancellables)
        completeTripButton
            .tapPublisher
            .sink {[weak self] _ in
                HapticManager.shared.feedBack(with: .heavy)
                guard let self = self else {return }
                self.delegate?.myTravelCellCollectionViewCellDidTapComplete(at: self.tag)
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        let titleSv = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        titleSv.axis = .vertical
        titleSv.distribution = .fill
        titleSv.alignment = .center
        titleSv.spacing = 8
        let totalSv = UIStackView(arrangedSubviews: [titleSv, completeTripButton, deleteButton])
        totalSv.axis = .vertical
        totalSv.distribution = .fill
        totalSv.alignment = .fill
        totalSv.spacing = 32
        [containerView, backgroundImageView, filterImageView, totalSv].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            filterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            filterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            filterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            filterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            totalSv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            totalSv.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            totalSv.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            totalSv.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
