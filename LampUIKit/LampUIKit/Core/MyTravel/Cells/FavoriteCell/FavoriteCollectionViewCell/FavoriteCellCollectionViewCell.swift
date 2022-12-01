//
//  FavoriteCellCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/28.
//
import Combine
import UIKit

protocol FavoriteCellCollectionViewCellDelegate: AnyObject {
    func favoriteCellCollectionViewCellDidTapDelete(at index: Int)
}

final class FavoriteCellCollectionViewCell: UICollectionViewCell, BodyCellable {
    static let identifier = "FavoriteCellCollectionViewCell"
    weak var delegate: FavoriteCellCollectionViewCellDelegate?
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.backgroundColor = .greyshWhite
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "경복궁"
        label.textColor = .darkNavy
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorite_saved"), for: .normal)
        return button
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "주소 어쩌구 저쩌구"
        label.textColor = .darkNavy
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    private var cancellables: Set<AnyCancellable>
    private var isSaveButtonTapped: Bool = true
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        configureShadow(0.4)
        bind()
        setupUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        favoriteButton.setImage(nil, for: .normal)
        addressLabel.text = nil
    }
    public func configure(_ model: MyBookMarkLocation) {
        titleLabel.text = model.placeName
        favoriteButton.setImage(UIImage(named: "favorite_saved"), for: .normal)
        addressLabel.text = model.placeAddr
    }
    private func bind() {
        favoriteButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                HapticManager.shared.feedBack(with: .heavy)
                self.isSaveButtonTapped.toggle()
                if self.isSaveButtonTapped {
                    self.favoriteButton.setImage(UIImage(named: "favorite_saved"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "favorite_unsaved"), for: .normal)
                    self.delegate?.favoriteCellCollectionViewCellDidTapDelete(at: self.tag)
                }
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        let totalSv = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        totalSv.axis = .vertical
        totalSv.alignment = .leading
        totalSv.distribution = .fillProportionally
        totalSv.spacing = 6
        [containerView, totalSv, favoriteButton].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            totalSv.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            totalSv.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            totalSv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            totalSv.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -48),
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            favoriteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
