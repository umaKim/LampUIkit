//
//  LocationDetailViewBodyCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import Combine
import UIKit

//
//private let satisfactionEvaluationView: EvaluationView = {
//    let models: [EvaluationModel] = [
//        EvaluationModel(isSelected: false, title: "매우 만족"),
//        EvaluationModel(isSelected: false, title: "만족"),
//        EvaluationModel(isSelected: false, title: "보통")
//    ]
//    let uv = EvaluationView(title: "만족도", elements: models)
//    uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
//    return uv
//}()
//
//private let atmosphereEvaluationView: EvaluationView = {
//    let models: [EvaluationModel] = [
//        EvaluationModel(isSelected: false, title: "고즈넉한"),
//        EvaluationModel(isSelected: false, title: "잔잔한"),
//        EvaluationModel(isSelected: false, title: "셍기넘치는"),
//        EvaluationModel(isSelected: false, title: "푸르른")
//    ]
//
//    let uv = EvaluationView(title: "분위기", elements: models)
//    uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
//    return uv
//}()
//
//private let surroundingEvaluationView: EvaluationView = {
//    let models: [EvaluationModel] = [
//        EvaluationModel(isSelected: false, title: "여유로운"),
//        EvaluationModel(isSelected: false, title: "혼잡한"),
//        EvaluationModel(isSelected: false, title: "인파가 적당한")
//    ]
//
//    let uv = EvaluationView(title: "주차 및 주변", elements: models)
//    uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
//    return uv
//}()
//
//private let foodEvaluationView: EvaluationView = {
//    let models: [EvaluationModel] = [
//        EvaluationModel(isSelected: false, title: "다양한 종류"),
//        EvaluationModel(isSelected: false, title: "먹거리 없음")
//    ]
//
//    let uv = EvaluationView(title: "먹거리", elements: models)
//    uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
//    return uv
//}()


enum RatingStandard {
    static let comfort: [String] = ["매우 만족", "만족", "보통"]
    static let atmosphere: [String] = ["고즈넉한", "잔잔한", "셍기넘치는", "푸르른"]
    static let surrounding: [String] = ["여유로운", "혼잡한", "인파가 적당한"]
    static let food: [String] = ["다양한 종류", "먹거리 없음"]
}

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
    
    public func configure(_ locationDetail: LocationDetailData) {
        guard let rate = locationDetail.totalAvgReviewRate else { return }
        let satisfactionIndex = rate.satisfaction ?? 0
        let moodIndex = rate.mood ?? 0
        let surroundIndex = rate.surround ?? 0
        let foodIndex = rate.foodArea ?? 0
        
        satisfyView.setSubtitle(RatingStandard.comfort[satisfactionIndex])
        atmosphereView.setSubtitle(RatingStandard.atmosphere[moodIndex])
        surroundingView.setSubtitle(RatingStandard.surrounding[surroundIndex])
        foodView.setSubtitle(RatingStandard.food[foodIndex])
    }
    
    private func bind() {
        showDetailButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.delegate?.locationDetailViewBodyCellDidTapShowDetail()
            }
            .store(in: &cancellables)
    }
    
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
        lb.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return lb
    }()
    
    private lazy var subTitleLabel = RoundedLabelView("")
    
    public func setSubtitle(_ text: String) {
        self.subTitleLabel.setText(text)
    }
    
    init(
        title: String,
        subTitle: String,
        spacing: CGFloat = 16,
        setRoundDesign: Bool = true
    ) {
        self.titleLabel.text = title
        super.init(frame: .zero)
        self.subTitleLabel.setText(subTitle)
        self.subTitleLabel.setRound(setRoundDesign)
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            
            heightAnchor.constraint(equalToConstant: 30)
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
