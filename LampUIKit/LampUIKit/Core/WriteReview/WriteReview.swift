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
    case updateSatisfactionModel(Int)
    case updateAtmosphereModel(Int)
    case updateSurroundingModel(Int)
    case updateFoodModel(Int)
    case updateComment(String)
    case addPhoto
    case removeImage(Int)
    case complete
}

class WriteReviewView: BaseWhiteView, ImageCollectionViewCellDelegate {
    func imageCollectionViewCellDidTapDelete(_ index: Int) {
        actionSubject.send(.removeImage(index))
        photos.remove(at: index)
        updateSections()
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
    
    private let profileView = LocationRectangleProfileView()
    
    public func configure(_ location: RecommendedLocation) {
        profileView.configure(location)
    }
    
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
        let models: [EvaluationModel] = RatingStandard.comfort
            .filter({
                $0 != "-"
            }).map { string in
                EvaluationModel(isSelected: false, title: string)
            }
        
        let uv = EvaluationView(title: "만족도", elements: models)
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    private let atmosphereEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = RatingStandard.atmosphere
            .filter({
                $0 != "-"
            }).map { string in
                EvaluationModel(isSelected: false, title: string)
            }
        
        let uv = EvaluationView(title: "분위기", elements: models)
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    private let surroundingEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = RatingStandard.surrounding
            .filter({
                $0 != "-"
            }).map { string in
                EvaluationModel(isSelected: false, title: string)
            }
        
        let uv = EvaluationView(title: "주차 및 주변", elements: models)
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    private let foodEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = RatingStandard.food
            .filter({
                $0 != "-"
            }).map { string in
                EvaluationModel(isSelected: false, title: string)
            }
        let uv = EvaluationView(title: "먹거리", elements: models)
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    private(set) lazy var textContextView: InputTextView = {
       let tv = InputTextView()
        tv.placeholderText = "내용을 입력하세요."
        tv.font = .robotoMedium(16)
        tv.backgroundColor = .greyshWhite
        tv.layer.cornerRadius = 6
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemGray.cgColor
        tv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return tv
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
    
    private lazy var selectedImageCollectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        cl.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(ImageCollectionHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: ImageCollectionHeaderView.identifier)
        cv.register(ImageCollectionViewCell.self,
                    forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        cv.delegate = self
        cv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cv.backgroundColor = .greyshWhite
        return cv
    }()
    
    private let dividerView3 = DividerView()
    
    private lazy var imageCounterLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.text = "0/3"
        lb.font = .robotoLight(13)
        return lb
    }()
    
    public func setImageCounter(_ count: Int) {
        imageCounterLabel.text = "\(count)/3"
    }
    
    private(set) lazy var completeButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "completeWriting_disable"), for: .normal)
        bt.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return bt
    }()
    
    private let contentView = UIView()
    
    override init() {
        super.init()
        
        addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        bind()
        setupUI()
        configureDataSource()
        updateSections()
    }
    
    public func setImage(with image: UIImage) {
        photos.append(image)
        updateSections()
    }
    
    private var photos: [UIImage] = []
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    public func ableCompleteButton(_ isAble: Bool) {
        self.completeButton.isEnabled = isAble
        completeButton.setImage(UIImage(named: self.completeButton.isEnabled ? "completeWriting_able" : "completeWriting_disable"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ImageCollectionHeaderViewDelegate
extension WriteReviewView: ImageCollectionHeaderViewDelegate {
    func imageCollectionHeaderViewDidTapAdd() {
        actionSubject.send(.addPhoto)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension WriteReviewView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 84, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: 84, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

//MARK: - Bind
extension WriteReviewView {
    private func bind() {
        delegate
            .$starValue
            .sink {[weak self] value in
                guard let self = self else {return}
                self.actionSubject.send(.updateStarRating(value))
            }
            .store(in: &cancellables)
        
        satisfactionEvaluationView.actionPublisher.sink {[weak self] action in
            guard let self = self else {return}
            switch action {
            case .updateElement(let model):
                self.actionSubject.send(.updateSatisfactionModel(model))
            }
        }
        .store(in: &cancellables)
        
        atmosphereEvaluationView.actionPublisher.sink {[weak self] action in
            guard let self = self else {return}
            switch action {
            case .updateElement(let model):
                self.actionSubject.send(.updateAtmosphereModel(model))
            }
        }
        .store(in: &cancellables)
        
        surroundingEvaluationView.actionPublisher.sink {[weak self] action in
            guard let self = self else {return}
            switch action {
            case .updateElement(let model):
                self.actionSubject.send(.updateSurroundingModel(model))
            }
        }
        .store(in: &cancellables)
        
        foodEvaluationView.actionPublisher.sink {[weak self] action in
            guard let self = self else {return}
            switch action {
            case .updateElement(let model):
                self.actionSubject.send(.updateFoodModel(model))
            }
        }
        .store(in: &cancellables)
        
        textContextView.textPublisher
            .compactMap({$0})
            .sink {[unowned self] text in
            self.actionSubject.send(.updateComment(text))
        }
        .store(in: &cancellables)
        
        completeButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.actionSubject.send(.complete)
        }
        .store(in: &cancellables)
    }
}

//MARK: - set up UI
extension WriteReviewView {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: selectedImageCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(self.photos[indexPath.item])
            cell.isDeleteButtonHidden = false
            cell.delegate = self
            cell.tag = indexPath.item
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
        
        let imageCounterSv = UIStackView(arrangedSubviews: [UIView(), imageCounterLabel])
        imageCounterSv.alignment = .trailing
        imageCounterSv.distribution = .fill
        
        let totalStackView = UIStackView(arrangedSubviews: [profileView,
                                                            dividerView1,
                                                            starRatingView,
                                                            evaluationStackView,
                                                            textContextView,
                                                            characterCounterSv,
                                                            dividerView2,
                                                            selectedImageCollectionView,
                                                            imageCounterSv,
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
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.height * 1.3),
            
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            starRatingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            starRatingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
