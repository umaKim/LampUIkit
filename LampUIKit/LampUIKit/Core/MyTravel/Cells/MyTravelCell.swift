//
//  MyTravelCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/18.
//
import Combine
import UIKit

final class MyTravelCellHeaderCell: UICollectionReusableView {
    static let identifier = "MyTravelCellHeaderCell"
    
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
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        editButton
            .tapPublisher
            .sink { _ in
                self.isEditButtonTapped.toggle()
                if self.isEditButtonTapped {
                    self.editButton.setTitle("완료", for: .normal)
                    self.delegate?.myTravelCellHeaderCellDidSelectEdit()
                } else {
                    self.editButton.setTitle("편집", for: .normal)
                    self.delegate?.myTravelCellHeaderCellDidSelectComplete()
                }
            }
            .store(in: &cancellables)
        
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

protocol MyTravelCellCollectionViewCellDelegate: AnyObject {
    func myTravelCellCollectionViewCellDidTapDelete(at index: Int)
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
    
    private var cancellables: Set<AnyCancellable>
    override init(frame: CGRect) {
        self.cancellables = .init()
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
        
        deleteButton.tapPublisher.sink { _ in
            self.delegate?.myTravelCellCollectionViewCellDidTapDelete(at: self.tag)
        }
        .store(in: &cancellables)
    }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MyTravelCell: UICollectionViewCell {
    static let identifier = "MyTravelCell"
    
    private lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(MyTravelCellHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: MyTravelCellHeaderCell.identifier)
        cv.register(MyTravelCellCollectionViewCell.self, forCellWithReuseIdentifier: MyTravelCellCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private var models: [String] = []
    
    public func configure(models: [String]) {
        self.models = models
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyTravelCell: MyTravelCellHeaderCellDelegate {
    func myTravelCellHeaderCellDidSelectComplete() {
        showDeleteButton.toggle()
        updateSections()
    }
    
    func myTravelCellHeaderCellDidSelectEdit() {
        showDeleteButton.toggle()
        updateSections()
    }
}

extension MyTravelCell: MyTravelCellCollectionViewCellDelegate {
    func myTravelCellCollectionViewCellDidTapDelete(at index: Int) {
        models.remove(at: index)
        updateSections()
    }
}

extension MyTravelCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: UIScreen.main.height / 4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.width, height: 60)
    }
}

//MARK: - set up UI
extension MyTravelCell {
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {
            self.dataSource?.applySnapshotUsingReloadData(snapshot)
        })
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyTravelCellCollectionViewCell.identifier,
                for: indexPath) as? MyTravelCellCollectionViewCell else { return nil }
            cell.delegate = self
            cell.tag = indexPath.item
            cell.showDeleButton = self.showDeleteButton
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyTravelCellHeaderCell.identifier, for: indexPath) as? MyTravelCellHeaderCell
            view?.delegate = self
            return view
        }
    }
    
    private func setupUI() {
        configureCollectionView()
        
        backgroundColor = .systemCyan
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
