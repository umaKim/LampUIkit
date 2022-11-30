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

enum WriteReviewViewAction: Actionable {
    case back
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

class WriteReviewView: BaseView<WriteReviewViewAction> {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    enum Section { case main }
    private var dataSource: DataSource?
    private var delegate: ContentViewDelegate = ContentViewDelegate()
    private(set) var backButton = UIBarButtonItem(image: .back, style: .plain, target: nil, action: nil)
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
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
        else { return UIView() }
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
        let view = EvaluationView(title: "만족도", elements: models)
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    private let atmosphereEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = RatingStandard.atmosphere
            .filter({
                $0 != "-"
            }).map { string in
                EvaluationModel(isSelected: false, title: string)
            }
        let view = EvaluationView(title: "분위기", elements: models)
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    private let surroundingEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = RatingStandard.surrounding
            .filter({
                $0 != "-"
            }).map { string in
                EvaluationModel(isSelected: false, title: string)
            }
        let view = EvaluationView(title: "주차 및 주변", elements: models)
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    private let foodEvaluationView: EvaluationView = {
        let models: [EvaluationModel] = RatingStandard.food
            .filter({
                $0 != "-"
            }).map { string in
                EvaluationModel(isSelected: false, title: string)
            }
        let view = EvaluationView(title: "먹거리", elements: models)
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    private(set) lazy var textContextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "내용을 입력하세요".localized
        textView.font = .robotoMedium(16)
        textView.backgroundColor = .greyshWhite
        textView.layer.cornerRadius = 6
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return textView
    }()
    private lazy var characterCounter: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "0/300"
        label.font = .robotoLight(13)
        return label
    }()
    public func setCharacterCounter(_ count: Int) {
        characterCounter.text = "\(count)/300"
    }
    private let dividerView2 = DividerView()
    private lazy var selectedImageCollectionView: BaseCollectionViewWithHeader<ImageCollectionHeaderView, ImageCollectionViewCell> = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 0)
        let collectionView = BaseCollectionViewWithHeader<ImageCollectionHeaderView, ImageCollectionViewCell>(cl)
        collectionView.delegate = self
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return collectionView
    }()
    private let dividerView3 = DividerView()
    private lazy var imageCounterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "0/3"
        label.font = .robotoLight(13)
        return label
    }()
    public func setImageCounter(_ count: Int) {
        imageCounterLabel.text = "\(count)/3"
    }
    private(set) lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "completeWriting_disableKr".localized), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
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
        completeButton.isEnabled = isAble
        completeButton.setImage(
            UIImage(named: completeButton.isEnabled ? "completeWriting_ableKr".localized : "completeWriting_disableKr".localized),
            for: .normal
        )
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ImageCollectionViewCellDelegate
extension WriteReviewView: ImageCollectionViewCellDelegate {
    func imageCollectionViewCellDidTapDelete(_ index: Int) {
        sendAction(.removeImage(index))
        photos.remove(at: index)
        updateSections()
    }
}

// MARK: - ImageCollectionHeaderViewDelegate
extension WriteReviewView: ImageCollectionHeaderViewDelegate {
    func imageCollectionHeaderViewDidTapAdd() {
        sendAction(.addPhoto)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WriteReviewView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(width: 84, height: 84)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: 84, height: 84)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }
}

// MARK: - Bind
extension WriteReviewView {
    private func bind() {
        backButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.back)
            }
            .store(in: &cancellables)
        delegate
            .$starValue
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink {[weak self] value in
                guard let self = self else {return}
                self.sendAction(.updateStarRating(value))
            }
            .store(in: &cancellables)
        satisfactionEvaluationView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .updateElement(let model):
                    self.sendAction(.updateSatisfactionModel(model))
                }
            }
            .store(in: &cancellables)
        atmosphereEvaluationView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .updateElement(let model):
                    self.sendAction(.updateAtmosphereModel(model))
                }
            }
            .store(in: &cancellables)
        surroundingEvaluationView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .updateElement(let model):
                    self.sendAction(.updateSurroundingModel(model))
                }
            }
            .store(in: &cancellables)
        foodEvaluationView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .updateElement(let model):
                    self.sendAction(.updateFoodModel(model))
                }
            }
            .store(in: &cancellables)
        textContextView
            .textPublisher
            .compactMap({$0})
            .sink {[weak self] text in
                guard let self = self else {return }
                self.sendAction(.updateComment(text))
            }
            .store(in: &cancellables)
        completeButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.complete)
            }
            .store(in: &cancellables)
    }
}

// MARK: - set up UI
extension WriteReviewView {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: selectedImageCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ImageCollectionViewCell.identifier,
                    for: indexPath
                ) as? ImageCollectionViewCell
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
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ImageCollectionHeaderView.identifier,
                for: indexPath
            ) as? ImageCollectionHeaderView
            view?.delegate = self
            return view
        }
    }
    private func setupUI() {
        let evaluationStackView = UIStackView(arrangedSubviews: [
            satisfactionEvaluationView,
            atmosphereEvaluationView,
            surroundingEvaluationView,
            foodEvaluationView
        ])
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
        let totalStackView = UIStackView(arrangedSubviews: [
            profileView,
            starRatingView,
            evaluationStackView,
            textContextView,
            characterCounterSv,
            selectedImageCollectionView,
            imageCounterSv,
            completeButton
        ])
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
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            starRatingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            starRatingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
