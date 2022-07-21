//
//  FavoriteCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/18.
//

import UIKit

final class FavoriteCellHeaderCell: UICollectionReusableView {
    static let identifier = "FavoriteCellHeaderCell"
    
    private lazy var goalDateLabel: UILabel = {
       let ul = UILabel()
        ul.text = "목표 날짜"
        ul.textColor = .black
        ul.font = .systemFont(ofSize: 15, weight: .semibold)
        return ul
    }()
    
    private lazy var editButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("편집", for: .normal)
        bt.titleLabel?.textColor = .red
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [editButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class FavoriteCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteCellCollectionViewCell"
    
    private let containerView: UIView = {
        let uv = UIView()
        uv.layer.cornerRadius = 6
        uv.layer.borderColor = UIColor.systemGray.cgColor
        uv.backgroundColor = .greyshWhite
        return uv
    }()
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "경복궁"
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        return lb
    }()
    
    private lazy var pinImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = .init(systemName: "person")
        return uv
    }()
    
    private lazy var addressLabel: UILabel = {
       let lb = UILabel()
        lb.text = "주소 어쩌구 저쩌구"
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureShadow(0.4)
        
        let totalSv = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        totalSv.axis = .vertical
        totalSv.alignment = .fill
        totalSv.distribution = .fill
        
        [containerView, totalSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            
            totalSv.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            totalSv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            totalSv.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class FavoriteCell: UICollectionViewCell {
    static let identifier = "FavoriteCell"
    
    private lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(FavoriteCellHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: FavoriteCellHeaderCell.identifier)
        cv.register(FavoriteCellCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCellCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemCyan
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private var models: [String] = []
    
    public func configure(models: [String]) {
        self.models = models
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoriteCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteCellHeaderCell.identifier, for: indexPath) as! FavoriteCellHeaderCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCellCollectionViewCell.identifier, for: indexPath) as? FavoriteCellCollectionViewCell
        else {return UICollectionViewCell()}
        return cell
    }
}

extension FavoriteCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: UIScreen.main.height / 4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.width, height: 60)
    }
}
