//
//  File.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/28.
//
import Combine
import UIKit

protocol MyTravelCellCollectionViewCellDelegate: AnyObject {
    func myTravelCellCollectionViewCellDidTapDelete(at index: Int)
    func myTravelCellCollectionViewCellDidTapComplete(at index: Int)
}

final class MyTravelCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyTravelCellCollectionViewCell"
    
    weak var delegate: MyTravelCellCollectionViewCellDelegate?
    
    private let containerView: UIView = {
        let uv = UIView()
        uv.layer.cornerRadius = 6
        uv.layer.borderColor = UIColor.systemGray.cgColor
        uv.backgroundColor = .greyshWhite
        return uv
    }()
    
    private let locationImageView: UIImageView = {
       let uv = UIImageView()
        uv.layer.cornerRadius = 6
        uv.clipsToBounds = true
        return uv
    }()
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "경복궁"
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        lb.numberOfLines = 1
        return lb
    }()
    
    private lazy var timeLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        lb.textColor = .midNavy
        return lb
    }()
    
    private lazy var addressLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .midNavy
        lb.font = .robotoMedium(14)
        return lb
    }()
    
    private lazy var deleteButton: UIButton = {
       let bt = UIButton()
        let image = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        bt.setImage(image, for: .normal)
        bt.isHidden = true
        return bt
    }()
    
    private lazy var completeTripButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "completeTrip"), for: .normal)
        bt.isHidden = false
        return bt
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        configureShadow(0.4)
        bind()
        setupUI()
    }
    
    public func configure(_ location: MyTravelLocation) {
        locationImageView.sd_setImage(with: URL(string: location.image ?? ""),
                                      placeholderImage: .placeholder)
        titleLabel.text = location.placeName
        timeLabel.text = location.placeInfo
        addressLabel.text = location.placeAddress
    }
    
    var showDeleButton: Bool? {
        didSet{
            deleteButton.isHidden = !(showDeleButton ?? false)
            completeTripButton.isHidden = showDeleButton ?? true
        }
    }
    
    public func bind() {
        deleteButton.tapPublisher.sink {[weak self] _ in
            HapticManager.shared.feedBack(with: .medium)
            guard let self = self else {return }
            self.delegate?.myTravelCellCollectionViewCellDidTapDelete(at: self.tag)
        }
        .store(in: &cancellables)
        
        completeTripButton.tapPublisher.sink {[weak self] _ in
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
        titleSv.alignment = .fill
        
        let upperSv = UIStackView(arrangedSubviews: [locationImageView, titleSv])
        upperSv.axis = .horizontal
        upperSv.distribution = .fill
        upperSv.alignment = .fill
        upperSv.spacing = 16
        
        [containerView, upperSv, deleteButton, completeTripButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            
            upperSv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            upperSv.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            upperSv.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            completeTripButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            completeTripButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
