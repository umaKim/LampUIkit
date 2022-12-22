//
//  ReviewViewCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/07.
//
import HapticManager
import Combine
import UIKit

protocol ReviewViewCollectionViewCellDelegate: AnyObject {
    func reviewViewCollectionViewCellDidTapLikeButton(_ index: Int)
    func reviewViewCollectionViewCellDidTapUnlikeButton(_ index: Int)
    func reviewViewCollectionViewCellDidTapReportButton(_ index: Int)
}

class ReviewViewCollectionViewCell: UICollectionViewCell, BodyCellable {
    static let identifier = "DetailReviewViewCollectionViewCell"
    weak var delegate: ReviewViewCollectionViewCellDelegate?
    private lazy var imageView: UIImageView = {
        let uv = UIImageView()
        uv.layer.cornerRadius = 6
        uv.clipsToBounds = true
        uv.contentMode = .scaleAspectFill
        uv.backgroundColor = .lightNavy
        uv.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return uv
    }()
    private lazy var starRatinView: UIImageView = {
        let uv = UIImageView()
        uv.contentMode = .scaleAspectFit
        uv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return uv
    }()
    private lazy var commentLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkNavy
        lb.textAlignment = .natural
        lb.numberOfLines = 0
        lb.sizeToFit()
        lb.font = .systemFont(ofSize: 10, weight: .semibold)
        return lb
    }()
    private lazy var likeButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.baseBackgroundColor = .midNavy
        config.cornerStyle = .capsule
        let image = UIImage(named: "like_selected")?.resize(to: 10)
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.attributedSubtitle = "".colored(to: .white)
        let button = UIButton(configuration: config)
        button.frame = .init(x: 0, y: 0, width: 62, height: 21)
        return button
    }()
    private lazy var reportButton: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 21/2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.titleLabel?.font = .robotoMedium(9)
        button.setTitle("신고하기".localized, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 52).isActive = true
        button.heightAnchor.constraint(equalToConstant: 21).isActive = true
        return button
    }()
    private var cancellables: Set<AnyCancellable>
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        bind()
        setupUI()
    }
    private var reviewData: ReviewData?
    public func configure(_ review: ReviewData) {
        self.reviewData = review
        let url = URL(string: (review.photoUrlArray?.first ?? ""))
        imageView.sd_setImage(with: url, placeholderImage: .placeholder)
        if let star = Double(review.star ?? "0") {
            starRatinView.image = .init(named: "\(star)")
        } else {
            starRatinView.image = .init(named: "0")
        }
        commentLabel.text = review.content
        likeButton.configuration?.attributedSubtitle = "\(review.numLiked)".colored(to: .midNavy)
        likeButton.isSelected = review.reviewILiked
        likeButton.setImage(
            UIImage(named: likeButton.isSelected ? "like_selected" : "like_unselected")?.resize(to: 10),
            for: .normal
        )
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Bind
extension ReviewViewCollectionViewCell {
    private func bind() {
        likeButton.tapPublisher.sink {[weak self] _ in
            guard
                let self = self,
                let reviewData = self.reviewData
            else {return }
            HapticManager.shared.feedBack(with: .heavy)
            self.likeButton.isSelected.toggle()
            if self.likeButton.isSelected {
                let numLiked = (reviewData.numLiked) + 1
                self.reviewData?.numLiked = numLiked
                self.likeButton.configuration?.attributedSubtitle = "\(numLiked)".colored(to: .white)
                self.likeButton.setImage(UIImage(named: "like_selected")?.resize(to: 10), for: .normal)
                self.delegate?.reviewViewCollectionViewCellDidTapLikeButton(self.tag)
            } else {
                let numLiked = (reviewData.numLiked) - 1
                self.reviewData?.numLiked = numLiked
                self.likeButton.configuration?.attributedSubtitle = "\(numLiked)".colored(to: .midNavy)
                self.likeButton.setImage(UIImage(named: "like_unselected")?.resize(to: 10), for: .normal)
                self.delegate?.reviewViewCollectionViewCellDidTapUnlikeButton(self.tag)
            }
        }
        .store(in: &cancellables)
        likeButton.subtitleLabel?.textColor = .lightNavy
        reportButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                HapticManager.shared.feedBack(with: .heavy)
                self.reportButton.isSelected.toggle()
                self.delegate?.reviewViewCollectionViewCellDidTapReportButton(self.tag)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Set up UI
extension ReviewViewCollectionViewCell {
    private func setupUI() {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        clipsToBounds = true
        let commentLabelSv = UIStackView(arrangedSubviews: [commentLabel])
        commentLabelSv.axis = .horizontal
        commentLabelSv.alignment = .top
        commentLabelSv.distribution = .fill
        let buttonSv = UIStackView(arrangedSubviews: [likeButton, reportButton])
        buttonSv.alignment = .fill
        buttonSv.distribution = .equalSpacing
        buttonSv.axis = .horizontal
        let starSv = UIStackView(arrangedSubviews: [starRatinView])
        starSv.axis = .vertical
        starSv.distribution = .fillProportionally
        starSv.alignment = .leading
        let sv = UIStackView(arrangedSubviews: [imageView, starSv, commentLabelSv, buttonSv])
        sv.distribution = .fill
        sv.alignment = .fill
        sv.axis = .vertical
        sv.spacing = 8
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            sv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            sv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            sv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13)
        ])
    }
}
