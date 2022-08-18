//
//  LocationDetailView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import Combine
import UIKit

enum LocationDetailViewAction {
    case back
}

final class LocationDetailView: BaseWhiteView {
    
    private(set) lazy var backButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LocationDetailViewAction, Never>()
    
    private(set) var collectionView: UICollectionView = {
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
        cv.backgroundColor = .greyshWhite
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    public func reload() {
        collectionView.reloadData()
    private func configureImageViewCollecitonView() {
        dataSource = DataSource(collectionView: locationImageView,
                                cellProvider: { collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(self.photoUrls[indexPath.item])
            return cell
        })
    }
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(photoUrls)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    }
    
    override init() {
        super.init()
        
        backButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.back)
            }
            .store(in: &cancellables)
        
        [collectionView].forEach { uv in
    private func setupUI() {
        addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStackView = UIStackView(arrangedSubviews: [label1, label2, label3, label4, label5])
        labelStackView.alignment = .leading
        labelStackView.distribution = .fillProportionally
        labelStackView.spacing = 16
        labelStackView.axis = .vertical
        
        [
            locationImageView,
            buttonSv,
            dividerView,
            labelStackView,
            addToMyTravelButton,
            totalTravelReviewView
        ].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
//            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.height * 1.5),
            
            locationImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            locationImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            locationImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
            locationImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
            
            buttonSv.topAnchor.constraint(equalTo: locationImageView.bottomAnchor),
            buttonSv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonSv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonSv.heightAnchor.constraint(equalToConstant: 95),
            
            dividerView.topAnchor.constraint(equalTo: buttonSv.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            labelStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelStackView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            
            addToMyTravelButton.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 40),
            addToMyTravelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addToMyTravelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToMyTravelButton.heightAnchor.constraint(equalToConstant: 60),
            
            totalTravelReviewView.topAnchor.constraint(equalTo: addToMyTravelButton.bottomAnchor, constant: 60),
            totalTravelReviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalTravelReviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            totalTravelReviewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.width-32,
                     height: UIScreen.main.width-32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
