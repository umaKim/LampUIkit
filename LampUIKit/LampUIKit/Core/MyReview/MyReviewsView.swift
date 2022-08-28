//
//  ReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import UIKit

class MyReviewsView: BaseWhiteView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private(set) lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(MyReviewHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: MyReviewHeaderCell.identifier)
        cv.register(MyReviewCollectionViewCell.self, forCellWithReuseIdentifier: MyReviewCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        return cv
    }()
    
    override init() {
        super.init()
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyReviewCollectionViewCell"
    
    private lazy var dateLabel: UILabel = {
       let lb = UILabel()
        lb.text = "2022년 8월 22일"
        return lb
    }()
    
    private lazy var optionButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "person"), for: .normal)
        return bt
    }()
    
    private lazy var imageView: UIImageView = {
       let uv = UIImageView()
        uv.image = .init(systemName: "person")
        uv.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 60).isActive = true
        uv.heightAnchor.constraint(equalToConstant: 161).isActive = true
        return uv
    }()
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "경복궁"
        return lb
    }()
    
    private lazy var commmentLabel: UILabel = {
       let lb = UILabel()
        lb.text = "jkwbfkewbfoubweofbweofbnweobfiouwebfiouweboufwe"
        return lb
    }()
    
    private lazy var starRateImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = .init(systemName: "person")
        return uv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .green
        
        let dateSv = UIStackView(arrangedSubviews: [dateLabel, optionButton])
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
        
        [totalSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalSv.bottomAnchor.constraint(equalTo: bottomAnchor),
            totalSv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyReviewHeaderCell: UICollectionReusableView {
    static let identifier = "MyReviewHeaderCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    public func configure() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
