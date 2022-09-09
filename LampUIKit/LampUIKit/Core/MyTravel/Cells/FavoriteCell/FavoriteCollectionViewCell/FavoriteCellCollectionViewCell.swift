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

final class FavoriteCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteCellCollectionViewCell"
    
    weak var delegate: FavoriteCellCollectionViewCellDelegate?
    
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
        lb.font = .systemFont(ofSize: 20, weight: .semibold)
        lb.numberOfLines = 1
        return lb
    }()
    
    private lazy var favoriteButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "favorite_saved"), for: .normal)
        return bt
    }()
    
    private lazy var addressLabel: UILabel = {
       let lb = UILabel()
        lb.text = "주소 어쩌구 저쩌구"
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        return lb
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    private var isSaveButtonTapped: Bool = true
    
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
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        bind()
        setupUI()
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
        totalSv.alignment = .fill
        totalSv.distribution = .fill
        totalSv.spacing = 6
        
        [containerView, totalSv, favoriteButton].forEach { uv in
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
            totalSv.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            favoriteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
