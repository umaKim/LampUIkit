//
//  ReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import Combine
import UIKit

enum MyReviewsViewAction {
    case back
}

class MyReviewsView: BaseWhiteView {

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MyReviewsViewAction, Never>()
    
    private(set) lazy var backButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(MyReviewCollectionViewCell.self, forCellWithReuseIdentifier: MyReviewCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        cv.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        return cv
    }()
    
    override init() {
        super.init()
        
        backButton.tapPublisher.sink {[weak self] _ in
            self?.actionSubject.send(.back)
        }
        .store(in: &cancellables)
        
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

protocol MyReviewCollectionViewCellDelegate: AnyObject {
    func MyReviewCollectionViewCellDidTapDelete(_ index: Int)
}

class MyReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyReviewCollectionViewCell"
    
    private lazy var dateLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .darkNavy
        return lb
    }()
    
    private lazy var deleteButton: UIButton = {
       let bt = UIButton()
        bt.setImage(.xmark, for: .normal)
        return bt
    }()
    
    private lazy var imageView: UIImageView = {
       let uv = UIImageView()
        uv.contentMode = .scaleAspectFill
        uv.layer.cornerRadius = 8
        uv.clipsToBounds = true
        uv.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 60).isActive = true
        uv.heightAnchor.constraint(equalToConstant: 161).isActive = true
        return uv
    }()
    
    private lazy var titleLabel: MyReviewCustomTitleView = {
        let lb = MyReviewCustomTitleView()
        lb.textColor = .darkNavy
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        return lb
    }()
    
    private lazy var commmentLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .darkNavy
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 13, weight: .semibold)
        return lb
    }()
    
    private lazy var starRateImageView: UIImageView = {
       let uv = UIImageView()
        return uv
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
                self.delegate?.MyReviewCollectionViewCellDidTapDelete(self.tag)
            }
            .store(in: &cancellables)
    }
    
    public func configure(with datum: UserReviewData) {
        dateLabel.text = datum.date
        if let url = datum.photoUrl {
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
        
        [totalSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            totalSv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            totalSv.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyReviewCustomTitleView: UIView {

    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        return lb
    }()
    
    init() {
        super.init(frame: .zero)
    
        layer.borderWidth = 1
        layer.cornerRadius = 9
        layer.borderColor = UIColor(red: 217/250, green: 217/250, blue: 217/250, alpha: 1).cgColor
        
        [titleLabel].forEach({ uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        })
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    var text: String? {
        didSet{
            titleLabel.text = text
        }
    }
    
    var textColor: UIColor? {
        didSet {
            titleLabel.textColor = textColor
        }
    }
    
    var font: UIFont? {
        didSet {
            titleLabel.font = font
        }
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
