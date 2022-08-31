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
    
    private(set) var contentView = LocationDetailView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    private let viewModel: LocationDetailViewModel
    
    weak var delegate: LocationDetailViewControllerDelegate?
    
    init(vm: LocationDetailViewModel) {
        self.viewModel = vm
        super.init()
        
        title = viewModel.location?.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isModal {
            navigationItem.rightBarButtonItems = [contentView.dismissButton]
        } else {
            navigationItem.leftBarButtonItems = [contentView.backButton]
        }
        
        setStatusBar()
        
        bind()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        viewModel.fetchLocationDetail()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[unowned self] action in
                HapticManager.shared.feedBack(with: .heavy)
                switch action {
                case .back:
                    self.delegate?.locationDetailViewControllerDidTapBackButton()
                    
                case .dismiss:
//                    self.dismiss(animated: true)
                    self.delegate?.locationDetailViewControllerDidTapDismissButton()
                    
                case .save:
                    self.viewModel.save()
                    
                case .ar:
                    guard let location = viewModel.location else { return }
                    let vm = ARViewModel(location)
                    let vc = ARViewController(vm)
                    self.present(vc, animated: true)
                    
                case .map:
                    guard let location = self.viewModel.location else {return}
                    self.delegate?.locationDetailViewControllerDidTapMapButton(location)
                    
                case .review:
                    guard let location = self.viewModel.location else {return }
                    let vm = WriteReviewViewModel(location)
                    let vc = WriteReviewViewController(vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case .addToMyTrip:
                    self.viewModel.addToMyTrip()
                    
                case .removeFromMyTrip:
                    self.viewModel.removeFromMyTrip()
                    
                case .showDetailReview:
                    if
                        let location = self.viewModel.location,
                        let locationDetail = self.viewModel.locationDetail {
                        let vm = DetailReviewViewModel(location, locationDetail)
                        let vc = DetailReviewViewController(vm: vm)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[unowned self] noti in
                switch noti {
                case .reload:
//                    self.contentView.reload()
                    break
                    
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
    
    func setStatusBar() {
//        if #available(iOS 13, *)
//        {
//            let keyWindow = UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .compactMap({$0 as? UIWindowScene})
//                .first?.windows
//                .filter({$0.isKeyWindow}).first
//            let statusBar = UIView(frame: (keyWindow?.windowScene?.statusBarManager?.statusBarFrame) ?? CGRect(x: 0, y: 0, width: UIScreen.main.width, height: 100))
//            statusBar.backgroundColor = .green
//            keyWindow?.addSubview(statusBar)
//        } else {
//            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//                statusBar.backgroundColor = .green
//            }
//            UIApplication.shared.statusBarStyle = .lightContent
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//
//extension LocationDetailViewController: LocationDetailViewHeaderCellDelegate {
//    func locationDetailViewHeaderCellDidTapSave() {
//        print("save")
//    }
//
//    func locationDetailViewHeaderCellDidTapReview() {
//        guard let location = viewModel.location else {return }
//        let vm = WriteReviewViewModel(location)
//        let vc = WriteReviewViewController(vm)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func locationDetailViewHeaderCellDidTapAr() {
//        let vm = ARViewModel()
//        let vc = ARViewController(vm: vm)
//        present(vc, animated: true)
//    }
//
//    func locationDetailViewHeaderCellDidTapShare() {
//
//        //TODO: start loading image
//        let vc = UIActivityViewController(
//            activityItems: [],
//            applicationActivities: nil)
//
//        present(vc, animated: true) {
//            //TODO: end loading image
//        }
//    }
//
//    func locationDetailViewHeaderCellDidTapAddToMyTrip() {
//        viewModel.addToMyTrip()
//    }
//
//    func locationDetailViewHeaderCellDidTapRemoveFromMyTrip() {
//        viewModel.removeFromMyTrip()
//    }
//}
//
//extension LocationDetailViewController: LocationDetailViewBodyCellDelegate {
//    func locationDetailViewBodyCellDidTapShowDetail() {
//        if
//            let location = viewModel.location,
//            let locationDetail = viewModel.locationDetail {
//            let vm = DetailReviewViewModel(location, locationDetail)
//            let vc = DetailReviewViewController(vm: vm)
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}
//
//extension LocationDetailViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        guard
//            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LocationDetailViewHeaderCell.identifier, for: indexPath) as? LocationDetailViewHeaderCell
//        else {return UICollectionReusableView() }
//        cell.delegate = self
//        if let location = viewModel.location,
//           let locationDetail = viewModel.locationDetail {
//            cell.configure(location, locationDetail)
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationDetailViewBodyCell.identifier, for: indexPath) as? LocationDetailViewBodyCell
//        else {return UICollectionViewCell()}
//        cell.delegate = self
//        return cell
//    }
//}
//
//extension LocationDetailViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let indexPath = IndexPath(row: 0, section: section)
//        let headerView = collectionView.dequeueReusableSupplementaryView(
//            ofKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: LocationDetailViewHeaderCell.identifier,
//            for: indexPath)
//        let size = headerView.systemLayoutSizeFitting(
//            CGSize(width: collectionView.frame.width,
//                   height: UIView.layoutFittingExpandedSize.height),
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .fittingSizeLevel)
//
//        return size
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        .init(width: UIScreen.main.width, height: UIScreen.main.height / 3)
//    }
//}
