//
//  LocationDetailViewBodyCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import Combine
import UIKit

protocol LocationDetailViewBodyCellDelegate: AnyObject {
    func locationDetailViewBodyCellDidTapShowDetail()
}

class LocationDetailViewBodyCell: UICollectionViewCell {
    static let identifier = "LocationDetailViewBodyCell"
    
    weak var delegate: LocationDetailViewBodyCellDelegate?
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "이 곳의 여행 후기"
        lb.textColor = .darkNavy
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        return lb
    }()
    
    private lazy var showDetailButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "showDetail"), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 80).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return bt
    }()
    
    private lazy var satisfyView: ReviewLabel = {
       let uv = ReviewLabel(title: "만족도", subTitle: "만족", setRoundDesign: false)
        return uv
    }()
    
    private lazy var atmosphereView: ReviewLabel = {
       let uv = ReviewLabel(title: "분위기", subTitle: "만족", setRoundDesign: false)
        return uv
    }()
    
    private lazy var surroundingView: ReviewLabel = {
       let uv = ReviewLabel(title: "주차 및 주변", subTitle: "만족", setRoundDesign: false)
        return uv
    }()
    
    private lazy var foodView: ReviewLabel = {
        let uv = ReviewLabel(title: "먹거리", subTitle: "만족", setRoundDesign: false)
        return uv
    }()
    
    private let dividerView = DividerView()
    
    public func configure() {
        
    }
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        bind()
        setupUI()
    }
    
    private func bind() {
        showDetailButton.tapPublisher.sink {[unowned self] _ in
            self.delegate?.locationDetailViewBodyCellDidTapShowDetail()
        }
        .store(in: &cancellables)
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func setupUI() {
        let verticalSv = UIStackView(arrangedSubviews: [satisfyView, atmosphereView, surroundingView, foodView])
        verticalSv.axis = .vertical
        verticalSv.alignment = .leading
        verticalSv.distribution = .fillEqually
        verticalSv.spacing = 21
        
        let headerSv = UIStackView(arrangedSubviews: [titleLabel, showDetailButton])
        headerSv.axis = .horizontal
        headerSv.alignment = .fill
        headerSv.distribution = .fill
        
        let sv = UIStackView(arrangedSubviews: [headerSv, verticalSv])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 18
        
        [sv, dividerView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            sv.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReviewLabel: UIView {
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        lb.textColor = .midNavy
        return lb
    }()
    
    private let subTitleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        lb.textColor = .black
        return lb
    }()
    
    init(
        title: String,
        subTitle: String,
        spacing: CGFloat = 16
    ) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        super.init(frame: .zero)
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = spacing
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(sv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
class RoundedLabelView: UIView {
    private let label: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        lb.textColor = .black
        return lb
    }()
    
    public func setText(_ text: String) {
        self.label.text = text
    }
    
    public func setRound(_ isRounded: Bool) {
        self.isRounded = isRounded
    }
    
    private var isRounded: Bool
    
    init(
        _ text: String,
        isRounded: Bool = true
    ) {
        self.label.text = text
        self.isRounded = isRounded
        super.init(frame: .zero)
        
        [label].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRounded {
            layer.borderWidth = 1
            layer.borderColor = UIColor.midNavy.cgColor
            layer.cornerRadius = self.frame.height / 2
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
