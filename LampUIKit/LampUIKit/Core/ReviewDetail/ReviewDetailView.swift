//
//  ReviewDetailView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/05.
//
import SDWebImage
import UIKit


class ReviewDetailImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReviewDetailImageCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
       let uv = UIImageView()
        uv.layer.cornerRadius = 6
        uv.clipsToBounds = true
        uv.contentMode = .scaleAspectFit
        return uv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with image: String) {
        imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(systemName: "placeholder"))
    }
    
    private func setupUI() {
        [imageView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}

class ReviewDetailView: BaseWhiteView {
    
    private(set) var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(ReviewDetailImageCollectionViewCell.self,
                    forCellWithReuseIdentifier: ReviewDetailImageCollectionViewCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let commentLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .semibold)
        lb.numberOfLines = 0
        return lb
    }()
    
    override init() {
        super.init()
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with data: ReviewData) {
        commentLabel.text = data.content ?? ""
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        let labelSv = UIStackView(arrangedSubviews: [commentLabel])
        labelSv.axis = .horizontal
        labelSv.distribution = .fill
        labelSv.alignment = .top
        
        [collectionView, labelSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -36),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.width),
            
            labelSv.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            labelSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            labelSv.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
