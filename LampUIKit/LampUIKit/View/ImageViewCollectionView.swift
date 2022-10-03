//
//  LocationImageViewCollectionView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/30.
//

import UIKit

class ImageViewCollectionView: UIView {
    public var photoUrls: [String] = []
    
    private lazy var locationImageView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    public override var backgroundColor: UIColor? {
        didSet {
            self.locationImageView.backgroundColor = backgroundColor
        }
    }
    
    private lazy var pageControl: UIPageControl = UIPageControl()
    
    init() {
        super.init(frame: .zero)
        
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = true
        
        [locationImageView, pageControl].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            locationImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            locationImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            locationImageView.topAnchor.constraint(equalTo: topAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: locationImageView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: locationImageView.bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let x = scrollView.contentOffset.x + (width/2)
        
        if (x == 0.0) && (width == 0.0) { return }
        
        let newPage = Int(x / width)
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
    
    public func reloadData() {
        self.locationImageView.reloadData()
    }
    
    public func setupPhotoUrls(_ urls: [String]) {
        self.photoUrls = urls
        self.pageControl.numberOfPages = urls.count
    }
    
    public var hidePageControl: Bool? {
        didSet {
            self.pageControl.isHidden = hidePageControl ?? false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDataSource
extension ImageViewCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
        else {return UICollectionViewCell()}
        cell.configure(self.photoUrls[indexPath.item])
        cell.isDeleteButtonHidden = true
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ImageViewCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.width - 32,
                     height: UIScreen.main.width / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
