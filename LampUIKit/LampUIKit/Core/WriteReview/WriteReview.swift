//
//  WriteReview.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import CombineCocoa
import Combine
import UIKit

enum WriteReviewViewAction {
    case updateSatisfactionModel([EvaluationModel])
    case updateAtmosphereModel([EvaluationModel])
    case updateSurroundingModel([EvaluationModel])
    case updateFoodModel([EvaluationModel])
}

class WriteReviewView: BaseWhiteView {

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LocationDetailViewAction, Never>()
    
    private let contentScrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let profileView: LocationRectangleProfileView = {
       let uv = LocationRectangleProfileView()
        return uv
    }()
    
    private let dividerView1 = DividerView()
    
    private let starRatingView: UIView = {
       let uv = UIView()
        uv.backgroundColor = .systemYellow
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    private let satisfactionEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = [
            EvaluationModel(isSelected: false, title: "매우 만족"),
            EvaluationModel(isSelected: false, title: "만족"),
            EvaluationModel(isSelected: false, title: "보통")
        ]
        let uv = EvaluationView(title: "만족도", elements: models)
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    private let atmosphereEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = [
            EvaluationModel(isSelected: false, title: "고즈넉한"),
            EvaluationModel(isSelected: false, title: "잔잔한"),
            EvaluationModel(isSelected: false, title: "셍기넘치는"),
            EvaluationModel(isSelected: false, title: "푸르른")
        ]
        
        let uv = EvaluationView(title: "분위기", elements: models)
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    private let surroundingEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = [
            EvaluationModel(isSelected: false, title: "여유로운"),
            EvaluationModel(isSelected: false, title: "혼잡한"),
            EvaluationModel(isSelected: false, title: "인파가 적당한")
        ]
        
        let uv = EvaluationView(title: "주차 및 주변", elements: models)
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    private let foodEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = [
            EvaluationModel(isSelected: false, title: "다양한 종류"),
            EvaluationModel(isSelected: false, title: "먹거리 없음")
        ]
        
        let uv = EvaluationView(title: "먹거리", elements: models)
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    private(set) lazy var textContextView: UITextView = {
        let ut = UITextView(frame: .zero)
        ut.layer.borderWidth = 1
        ut.layer.borderColor = UIColor.gray.cgColor
        ut.layer.cornerRadius = 5
        ut.backgroundColor = .white
        return ut
    }()
    
    private let dividerView2 = DividerView()
    
    private let dividerView3 = DividerView()
    
    private(set) lazy var textButton: RectangleTextButton = {
        let bt = RectangleTextButton("작성을 완료하기", background: .midNavy, fontSize: 17)
        bt.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return bt
    }()
    
    private let contentView = UIView()
    
    private func bind() {
        satisfactionEvaluationView.actionPublisher.sink { action in
            switch action {
            case .updateElement(let models):
                print(models)
            }
        }
        .store(in: &cancellables)
        
        atmosphereEvaluationView.actionPublisher.sink { action in
            switch action {
            case .updateElement(let models):
                print(models)
            }
        }
        .store(in: &cancellables)
        
        surroundingEvaluationView.actionPublisher.sink { action in
            switch action {
            case .updateElement(let models):
                print(models)
            }
        }
        .store(in: &cancellables)
        
        foodEvaluationView.actionPublisher.sink { action in
            switch action {
            case .updateElement(let models):
                self.actionSubject.send(.)
            }
        }
        .store(in: &cancellables)
        
    }
    
    override init() {
        super.init()
        
        addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        bind()
        setupUI()
    }
    
    private func setupUI() {
        let evaluationStackView = UIStackView(arrangedSubviews: [satisfactionEvaluationView,
                                                                 atmosphereEvaluationView,
                                                                 surroundingEvaluationView,
                                                                 foodEvaluationView])
        evaluationStackView.axis = .vertical
        evaluationStackView.distribution = .fill
        evaluationStackView.alignment = .fill
        evaluationStackView.spacing = 16
        
        let totalStackView = UIStackView(arrangedSubviews: [profileView,
                                                            dividerView1,
                                                            starRatingView,
                                                            evaluationStackView,
                                                            textContextView,
                                                            dividerView2,
                                                            dividerView3,
                                                            textButton])
        totalStackView.axis = .vertical
        totalStackView.distribution = .fill
        totalStackView.alignment = .fill
        totalStackView.spacing = 16
        
        [totalStackView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.height * 1.00005),
            
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
