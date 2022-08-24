//
//  LocationDetailViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//
import Combine
import UIKit

protocol LocationDetailViewControllerDelegate: AnyObject {
    func locationDetailViewControllerDidTapDismissButton()
    func locationDetailViewControllerDidTapMapButton(_ location: RecommendedLocation)
}

final class LocationDetailViewController: BaseViewContronller {
    
    private let contentView = LocationDetailView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    private let viewModel: LocationDetailViewModel
    
    weak var delegate: LocationDetailViewControllerDelegate?
    
    init(vm: LocationDetailViewModel) {
        self.viewModel = vm
        super.init()
        
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        
        navigationItem.leftBarButtonItems = [contentView.backButton]
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchLocationDetail()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[unowned self] action in
                HapticManager.shared.feedBack(with: .heavy)
                switch action {
                case .back:
                    self.navigationController?.popViewController(animated: true)
                    
                case .dismiss:
//                    self.dismiss(animated: true)
                    self.delegate?.locationDetailViewControllerDidTapDismissButton()
                    
                case .save:
                    self.viewModel.save()
                    
                case .ar:
                    let vm = ARViewModel()
                    let vc = ARViewController(vm: vm)
                    self.present(vc, animated: true)
                    
                case .map:
                    guard let location = self.viewModel.location else {return}
                    self.delegate?.locationDetailViewControllerDidTapMapButton(location)
                    
                case .review:
                    guard let location = self.viewModel.location else {return }
                    let vm = WriteReviewViewModel(location)
                    let vc = WriteReviewViewController(vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                
                case .share:
                    let vc = UIActivityViewController(
                        activityItems: [],
                        applicationActivities: nil)
                    
                    self.present(vc, animated: true)
                    
                case .addToMyTrip:
                    self.viewModel.addToMyTrip()
                    
                case .removeFromMyTrip:
                    self.viewModel.removeFromMyTrip()
                    
                case .showDetailReview:
                    let vm = DetailReviewViewModel()
                    let vc = DetailReviewViewController(vm: vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[unowned self] noti in
                switch noti {
                case .reload:
                    self.contentView.reload()
                    
                case .startLoading:
                    self.showLoadingView()
                    
                case .endLoading:
                    self.dismissLoadingView()
                    
                case .sendLocationDetail(let data):
                    if let data = data {
                        self.contentView.configure(data)
                        self.contentView.configureDetailInfo(data)
                    }
                    
                case .locationDetailImages(let images):
                    self.contentView.configure(with: images)
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationDetailViewController: LocationDetailViewHeaderCellDelegate {
    func locationDetailViewHeaderCellDidTapSave() {
        
    }
    
    func locationDetailViewHeaderCellDidTapReview() {
        let vm = WriteReviewViewModel()
        let vc = WriteReviewViewController(vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func locationDetailViewHeaderCellDidTapAr() {
        let vm = ARViewModel()
        let vc = ARViewController(vm: vm)
        present(vc, animated: true)
    }
    
    func locationDetailViewHeaderCellDidTapShare() {
        
        //TODO: start loading image
        
        let vc = UIActivityViewController(
            activityItems: [],
            applicationActivities: nil)
        
        present(vc, animated: true) {
            //TODO: end loading image
        }
    }
    
    func locationDetailViewHeaderCellDidTapAddToMyTrip() {
        viewModel.addToMyTrip()
    }
    
    func locationDetailViewHeaderCellDidTapRemoveFromMyTrip() {
        viewModel.removeFromMyTrip()
    }
}

extension LocationDetailViewController: LocationDetailViewBodyCellDelegate {
    func locationDetailViewBodyCellDidTapShowDetail() {
        let vm = DetailReviewViewModel()
        let vc = DetailReviewViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LocationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LocationDetailViewHeaderCell.identifier, for: indexPath) as! LocationDetailViewHeaderCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationDetailViewBodyCell.identifier, for: indexPath) as? LocationDetailViewBodyCell else {return UICollectionViewCell()}
        cell.delegate = self
        return cell
    }
}

extension LocationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: LocationDetailViewHeaderCell.identifier,
            for: indexPath)
        let size = headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width, height: UIScreen.main.height / 3)
    }
}
