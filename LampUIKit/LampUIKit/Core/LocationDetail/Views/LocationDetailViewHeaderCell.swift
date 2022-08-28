//
//  LocationDetailViewHeaderCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import Combine
import UIKit

protocol LocationDetailViewHeaderCellDelegate: AnyObject {
    func locationDetailViewHeaderCellDidTapSave()
    func locationDetailViewHeaderCellDidTapReview()
    func locationDetailViewHeaderCellDidTapAr()
    func locationDetailViewHeaderCellDidTapShare()
    func locationDetailViewHeaderCellDidTapAddToMyTrip()
    func locationDetailViewHeaderCellDidTapRemoveFromMyTrip()
}

    private lazy var imageView: UIImageView = {
       let uv = UIImageView()
        uv.contentMode = .scaleAspectFill
        uv.layer.cornerRadius = 6
        uv.clipsToBounds = true
        return uv
    }()
    
    private lazy var dismissButton: UIButton = {
        let bt = UIButton()
//        bt.setImage(.xmark, for: .normal)
        bt.setImage(UIImage(named: "minus"), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bt.layer.cornerRadius = 20/2
        bt.backgroundColor = .greyshWhite
        return bt
    }()
    
    }
    
    }
    
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dismissButton.tapPublisher.sink {[unowned self] _ in
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LocationDetailViewHeaderCell: UICollectionReusableView {
    
    static let identifier = "LocationDetailViewHeaderCell"
    
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>

    enum Section { case main }

    private var dataSource: DataSource?
    
    private lazy var locationImageView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        cv.delegate = self
        cv.backgroundColor = .red
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let buttonSv = LocationDetailViewHeaderCellButtonStackView()
    
    private let dividerView = DividerView()
    
    private let timeLabel: LocationDescriptionView = {
        let uv = LocationDescriptionView("관람시간", description: "09:00~18:30 (입장마감은 17:30)")
        uv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return uv
    }()
    
    private let priceLabel: LocationDescriptionView = {
        let uv = LocationDescriptionView("관람요금",
                                         description: "성인 : 3,000원 (개인) |  2,400원 (단체) \n만 65세 이상 / 만 6세 이하  : 무료\n소인 : 1,500원 (개인) | 1,200원 (단체)")
        uv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return uv
    }()
    
    private lazy var addToMyTravelButton = RectangleTextButton("내 여행지로 추가", background: .midNavy, textColor: .white, fontSize: 17)
    
    weak var delegate: LocationDetailViewHeaderCellDelegate?
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        bind()
        setupUI()
        
        configureImageViewCollecitonView()
        updateSections()
    }
    
    private func configureImageViewCollecitonView() {
        dataSource = DataSource(collectionView: locationImageView,
                                cellProvider: { collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure("")
            return cell
        })
    }
        updateSections()
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(photoUrls)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        buttonSv
            .actionPublisher
            .sink {[unowned self] action in
                switch action {
                case .save:
                    self.delegate?.locationDetailViewHeaderCellDidTapSave()
                    
                case .ar:
                    self.delegate?.locationDetailViewHeaderCellDidTapAr()
                    
                case .review:
                    self.delegate?.locationDetailViewHeaderCellDidTapReview()
                    
                case .share:
                    self.delegate?.locationDetailViewHeaderCellDidTapShare()
                }
            }
            .store(in: &cancellables)
        
        addToMyTravelButton
            .tapPublisher
            .sink {[unowned self] _ in
                self.addToMyTravelButton.isSelected.toggle()
                
                if self.addToMyTravelButton.isSelected {
                    self.addToMyTravelButton.update("내여행지로 추가 취소", background: .systemGray, textColor: .white)
                    self.delegate?.locationDetailViewHeaderCellDidTapAddToMyTrip()
                } else {
                    self.addToMyTravelButton.update("내여행지로 추가", background: .midNavy, textColor: .white)
                    self.delegate?.locationDetailViewHeaderCellDidTapRemoveFromMyTrip()
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationDetailViewHeaderCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.width-32,
                     height: UIScreen.main.width-32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
    private func setupUI() {
        let labelStackView = UIStackView(arrangedSubviews: [timeLabel, priceLabel])
        labelStackView.alignment = .leading
        labelStackView.distribution = .fill
        labelStackView.spacing = 16
        labelStackView.axis = .vertical
        
        [locationImageView, buttonSv, dividerView, labelStackView, addToMyTravelButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            locationImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
            locationImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
            
            buttonSv.topAnchor.constraint(equalTo: locationImageView.bottomAnchor),
            buttonSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonSv.heightAnchor.constraint(equalToConstant: 95),
            
            dividerView.topAnchor.constraint(equalTo: buttonSv.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            
            addToMyTravelButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            addToMyTravelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addToMyTravelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addToMyTravelButton.heightAnchor.constraint(equalToConstant: 60),
            addToMyTravelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60)
        ])
    }
}
