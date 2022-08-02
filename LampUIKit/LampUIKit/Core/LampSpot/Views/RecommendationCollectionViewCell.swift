//
//  RecommendationCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import UIKit

protocol RecommendationCollectionViewCellDelegate: AnyObject {
    func recommendationCollectionViewCellDidSelect(itemAt indexPath: IndexPath)
}

class RecommendationCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedLocationCell.identifier, for: indexPath) as? RecommendedLocationCell else {return UICollectionViewCell()}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.recommendationCollectionViewCellDidSelect(itemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.width / 4, height: UIScreen.main.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    weak var delegate: RecommendationCollectionViewCellDelegate?
    
    static let identifier = "RecommendationCollectionViewCell"
    
    private let titleLabel:UILabel = {
       let lb = UILabel()
        lb.text = "당신에게 추천하는 여행지"
        lb.font = .robotoBold(20)
        lb.textColor = .black
        return lb
    }()
    
    private let collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .greyshWhite
        return cv
    }()
    
    var models: [String]? {
        didSet {
            self.collectionView.reloadData()
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .greyshWhite
        
        collectionView.register(RecommendedLocationCell.self, forCellWithReuseIdentifier: RecommendedLocationCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel])
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fill
        labelStackView.spacing = 6
        
        [labelStackView, collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//class RecommendationCollectionViewModel {
//    private(set) var models = ["data1", "data2", "data3", "data4", "data5", "data6"]
//}
//
//class RecommendationCollectionView: UIView {
//
//    private let titleLabel: UILabel = {
//       let lb = UILabel()
//        lb.text = "당신에게 추천하는 여행지"
//        lb.font = .systemFont(ofSize: 20, weight: .semibold)
//        return lb
//    }()
//
//    private(set) var collectionView : UICollectionView = {
//       let cl = UICollectionViewFlowLayout()
//        cl.scrollDirection = .horizontal
//
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
//        cv.register(RecommendedLocationCell.self, forCellWithReuseIdentifier: RecommendedLocationCell.identifier)
//        return cv
//    }()
//
//    init() {
//        super.init(frame: .zero)
//
//        [titleLabel, collectionView].forEach { uv in
//            uv.translatesAutoresizingMaskIntoConstraints = false
//            addSubview(uv)
//        }
//
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//
//            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
class RecommendedLocationCell: UICollectionViewCell {
    static let identifier = "RecommendedLocationCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 16
        backgroundColor = .orange
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//
//class RecommendationCollectionViewController: UIViewController {
//
//    private let contentView = RecommendationCollectionView()
//    private var viewModel: RecommendationCollectionViewModel
//
//    func configure(with vm: RecommendationCollectionViewModel) {
//        self.viewModel = vm
//    }
//
//    override func loadView() {
//        super.loadView()
//        view = contentView
//    }
//
//    init(vm: RecommendationCollectionViewModel) {
//        self.viewModel = vm
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        contentView.collectionView.dataSource = self
//        contentView.collectionView.delegate = self
//    }
//}
//
//extension RecommendationCollectionViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("Cell Count")
//        return viewModel.models.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedLocationCell.identifier, for: indexPath) as? RecommendedLocationCell
//        else {return UICollectionViewCell()}
//        print("Cell Item")
//        return cell
//    }
//}
//
//extension RecommendationCollectionViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("\(indexPath.item)")
//    }
//}
//
//extension RecommendationCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("Cell size")
//        return .init(width: UIScreen.main.width / 4, height: UIScreen.main.width / 4)
//    }
//}
