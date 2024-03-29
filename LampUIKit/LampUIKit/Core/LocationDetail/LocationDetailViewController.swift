//
//  LocationDetailViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//
import HapticManager
import SkeletonView
import Combine
import UIKit

protocol LocationDetailViewControllerDelegate: AnyObject {
    func locationDetailViewControllerDidTapDismissButton()
    func locationDetailViewControllerDidTapBackButton()
    func locationDetailViewControllerDidTapMapButton(_ location: RecommendedLocation)
    func locationDetailViewControllerDidTapNavigate(_ location: RecommendedLocation)
}

final class LocationDetailViewController: BaseViewController<LocationDetailView, LocationDetailViewModel> {
    weak var delegate: LocationDetailViewControllerDelegate?
    var isModal: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.location?.title
        if isModal {
            navigationItem.rightBarButtonItems = [contentView.dismissButton]
        } else {
            navigationItem.leftBarButtonItems = [contentView.backButton]
        }
        configureNavigationController()
        bind()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchLocationDetail()
    }
    private func scrollToButtonSv() {
        contentView.scrollToButtonSv()
    }
    private func configureNavigationController() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .greyshWhite
    }
}

// MARK: - Bind
extension LocationDetailViewController {
    private func bind() {
        bind(with: contentView)
        bind(with: viewModel)
    }
    private func bind(with locationDetailView: LocationDetailView) {
        locationDetailView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                HapticManager.shared.feedBack(with: .heavy)
                switch action {
                case .back:
                    self.delegate?.locationDetailViewControllerDidTapBackButton()
                case .dismiss:
                    self.delegate?.locationDetailViewControllerDidTapDismissButton()
                case .save:
                    self.viewModel.save()
                case .ar:
                    guard let location = self.viewModel.location else { return }
                    let viewModel = ARViewModel(location)
                    let viewController = ARViewController(ARView(), viewModel)
                    self.present(viewController, animated: true)
                case .map:
                    guard let location = self.viewModel.location else {return}
                    self.delegate?.locationDetailViewControllerDidTapMapButton(location)
                    self.scrollToButtonSv()
                case .review:
                    guard let location = self.viewModel.location else {return }
                    let viewModel = WriteReviewViewModel(location)
                    let viewController = WriteReviewViewController(WriteReviewView(), viewModel)
                    self.navigationController?.pushViewController(viewController, animated: true)
                case .addToMyTrip:
                    self.viewModel.addToMyTrip()
                case .removeFromMyTrip:
                    self.viewModel.removeFromMyTrip()
                case .showDetailReview:
                    if
                        let location = self.viewModel.location,
                        let locationDetail = self.viewModel.locationDetail {
                        let viewModel = ReviewViewModel(location, locationDetail)
                        let viewController = ReviewViewController(ReviewView(), viewModel)
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
    private func bind(with viewModel: LocationDetailViewModel) {
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .startLoading:
                    self.contentView.showSkeleton()
                case .endLoading:
                    self.contentView.hideSkeleton()
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
}
