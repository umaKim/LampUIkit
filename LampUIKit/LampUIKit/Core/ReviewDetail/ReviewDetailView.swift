//
//  ReviewDetailView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/05.
//
import SDWebImage
import UIKit

enum ReviewDetailViewAction: Actionable {
    case back
}

class ReviewDetailView: BaseView<ReviewDetailViewAction> {
    private(set) lazy var backButton = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
    private(set) var collectionView = ImageViewCollectionView()
    private let commentLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .semibold)
        lb.numberOfLines = 0
        lb.textColor = .white
        return lb
    }()
    override init() {
        super.init()
        bind()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with data: ReviewDetailData ) {
        collectionView.setupPhotoUrls(data.photoUrlArray)
        commentLabel.text = data.content
    }
    private func bind() {
        backButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.sendAction(.back)
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        backgroundColor = .black
        let labelSv = UIStackView(arrangedSubviews: [commentLabel])
        labelSv.axis = .horizontal
        labelSv.distribution = .fill
        labelSv.alignment = .top
        collectionView.backgroundColor = .black
        [collectionView, labelSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -36),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.width),
            labelSv.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            labelSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            labelSv.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
