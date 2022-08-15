//
//  WriteReview.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import SwiftUI
import AxisRatingBar
import CombineCocoa
import Combine
import UIKit

enum WriteReviewViewAction {
    case updateStarRating(CGFloat)
    case updateSatisfactionModel(EvaluationModel)
    case updateAtmosphereModel(EvaluationModel)
    case updateSurroundingModel(EvaluationModel)
    case updateFoodModel(EvaluationModel)
    case updateComment(String)
}

class ContentViewDelegate: ObservableObject {
    @Published var starValue: CGFloat = 2.5
}

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WriteReviewViewAction, Never>()

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    private var delegate: ContentViewDelegate = ContentViewDelegate()
    
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
    
    private lazy var starRatingView: UIView = {
        let view = CustomRatingBar(axisMode: .horizontal, delegate: delegate)
        guard
            let uv = UIHostingController(rootView: view).view
        else {return UIView()}
        uv.backgroundColor = .greyshWhite
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
        ut.textColor = .black
        return ut
    }()
    
    private lazy var characterCounter: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.text = "0/300"
        lb.font = .robotoLight(13)
        return lb
    }()
    
    public func setCharacterCounter(_ count: Int) {
        characterCounter.text = "\(count)/300"
    }
    
    private let dividerView2 = DividerView()
    
    private let dividerView3 = DividerView()
    
    private(set) lazy var completeButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "completeWriting_disable"), for: .normal)
        bt.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return bt
    }()
    
    private let contentView = UIView()
    
        updateSections()
        
        updateSections()
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    private func bind() {
        delegate
            .$starValue
            .sink { value in
                self.actionSubject.send(.updateStarRating(value))
            }
            .store(in: &cancellables)
        
        satisfactionEvaluationView.actionPublisher.sink { action in
            switch action {
            case .updateElement(let model):
                self.actionSubject.send(.updateSatisfactionModel(model))
            }
        }
        .store(in: &cancellables)
        
        atmosphereEvaluationView.actionPublisher.sink { action in
            switch action {
            case .updateElement(let model):
                self.actionSubject.send(.updateAtmosphereModel(model))
            }
        }
        .store(in: &cancellables)
        
        surroundingEvaluationView.actionPublisher.sink { action in
            switch action {
            case .updateElement(let model):
                self.actionSubject.send(.updateSurroundingModel(model))
            }
        }
        .store(in: &cancellables)
        
        foodEvaluationView.actionPublisher.sink { action in
            switch action {
            case .updateElement(let model):
                self.actionSubject.send(.updateFoodModel(model))
            }
        }
        .store(in: &cancellables)
        
        textContextView.textPublisher
            .compactMap({$0})
            .sink { text in
            self.actionSubject.send(.updateComment(text))
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
    
    public func ableCompleteButton(_ isAble: Bool) {
        self.completeButton.isEnabled = isAble
    private func configureDataSource() {
        dataSource = DataSource(collectionView: imageCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(self.photos[indexPath.item])
            cell.backgroundColor = .blue
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImageCollectionHeaderView.identifier, for: indexPath) as? ImageCollectionHeaderView
            view?.delegate = self
            return view
        }
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
        
        let characterCounterSv = UIStackView(arrangedSubviews: [UIView(), characterCounter])
        characterCounterSv.alignment = .trailing
        characterCounterSv.distribution = .fill
        
        let totalStackView = UIStackView(arrangedSubviews: [profileView,
                                                            dividerView1,
                                                            starRatingView,
                                                            evaluationStackView,
                                                            textContextView,
                                                            characterCounterSv,
                                                            dividerView2,
                                                            dividerView3,
                                                            completeButton])
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
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            starRatingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            starRatingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
