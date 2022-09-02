//
//  CompletedTravelCellCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/05.
//
import Combine
import UIKit

protocol CompletedTravelCellCollectionViewCellDelegate: AnyObject {
    func completedTravelCellCollectionViewCellDidTapDelete(at index: Int)
}

final class CompletedTravelCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "CompletedTravelCellCollectionViewCell"
    
    private lazy var backgroundImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(named: "ticketBackground")
        return uv
    }()
    
    private lazy var visitiedDateLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        lb.textColor = .black
        return lb
    }()
    
    private lazy var locationNameLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        lb.textColor = .midNavy
        return lb
    }()
    
    private lazy var deleteButton: UIButton = {
       let bt = UIButton()
        let image = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        bt.setImage(image, for: .normal)
//        bt.isHidden = true
        return bt
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    weak var delegate: CompletedTravelCellCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        deleteButton.tapPublisher.sink { _ in
            self.delegate?.completedTravelCellCollectionViewCellDidTapDelete(at: self.tag)
        }
        .store(in: &cancellables)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundView = backgroundImageView
        configureShadow()
        
        [visitiedDateLabel, locationNameLabel, deleteButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            visitiedDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 46),
            visitiedDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            
            locationNameLabel.leadingAnchor.constraint(equalTo: visitiedDateLabel.leadingAnchor),
            locationNameLabel.topAnchor.constraint(equalTo: visitiedDateLabel.bottomAnchor, constant: 20),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    public func configure(_ model: MyCompletedTripLocation) {
        visitiedDateLabel.text = model.travelCompletedDate
        locationNameLabel.text = model.placeName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
