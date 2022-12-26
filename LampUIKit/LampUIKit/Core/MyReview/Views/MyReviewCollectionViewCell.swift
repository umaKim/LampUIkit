//
//  MyReviewCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//
import Combine
import UIKit

protocol MyReviewCollectionViewCellDelegate: AnyObject {
    func myReviewCollectionViewCellDidTapDelete(_ index: Int)
}

class MyReviewCollectionViewCell: UICollectionViewCell, BodyCellable {
    static let identifier = "MyReviewCollectionViewCell"
    private lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .darkNavy
        return label
    }()
    private lazy var deleteButton: UIButton = {
       let button = UIButton()
        button.setImage(.xmark, for: .normal)
        return button
    }()
    private lazy var imageView: UIImageView = {
       let uiView = UIImageView()
        uiView.contentMode = .scaleAspectFill
        uiView.layer.cornerRadius = 8
        uiView.clipsToBounds = true
        uiView.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 60).isActive = true
        uiView.heightAnchor.constraint(equalToConstant: 161).isActive = true
        return uiView
    }()
    private lazy var titleLabel: MyReviewCustomTitleView = {
        let label = MyReviewCustomTitleView()
        label.textColor = .darkNavy
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private lazy var commmentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkNavy
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    private lazy var starRateImageView: UIImageView = {
        let uiView = UIImageView()
        return uiView
    }()
    private var cancellables: Set<AnyCancellable>
    weak var delegate: MyReviewCollectionViewCellDelegate?
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: .zero)
        bind()
        setupUI()
    }
    private func bind() {
        deleteButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.delegate?.myReviewCollectionViewCellDidTapDelete(self.tag)
            }
            .store(in: &cancellables)
    }
    public func configure(with datum: UserReviewData) {
        dateLabel.text = datum.date
        if let url = datum.photoUrl.first {
            imageView.sd_setImage(with: URL(string: url), placeholderImage: .placeholder)
        }
        titleLabel.text = datum.placeName
        commmentLabel.text = datum.content
        guard let star = Double(datum.star) else {return }
        starRateImageView.image = .init(named: "\(star)")
    }
    private func setupUI() {
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor(red: 217/250, green: 217/250, blue: 217/250, alpha: 1).cgColor
        let dateSv = UIStackView(arrangedSubviews: [dateLabel, deleteButton])
        dateSv.alignment = .fill
        dateSv.distribution = .fill
        dateSv.axis = .horizontal
        let titleSv = UIStackView(arrangedSubviews: [titleLabel])
        titleSv.alignment = .fill
        titleSv.distribution = .fill
        titleSv.axis = .horizontal
        let commentAlign = UIStackView(arrangedSubviews: [commmentLabel])
        commentAlign.axis = .horizontal
        commentAlign.alignment = .top
        commentAlign.distribution = .fill
        let commentSv = UIStackView(arrangedSubviews: [commentAlign, starRateImageView])
        commentSv.axis = .vertical
        commentSv.distribution = .fill
        commentSv.alignment = .center
        let totalSv = UIStackView(arrangedSubviews: [dateSv, imageView, titleSv, commentAlign, commentSv])
        totalSv.axis = .vertical
        totalSv.alignment = .fill
        totalSv.distribution = .fill
        totalSv.spacing = 16
        contentView.addSubviews(totalSv)
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            totalSv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            totalSv.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
