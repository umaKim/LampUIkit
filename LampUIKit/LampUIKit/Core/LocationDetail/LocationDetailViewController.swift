//
//  LocationDetailViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//
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
        
        bind()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.barTintColor = .greyshWhite
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchLocationDetail()
    }
    
    private func bind() {
        contentView
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
                    let vm = ARViewModel(location)
                    let vc = ARViewController(ARView(), vm)
                    self.present(vc, animated: true)
                    
                case .map:
                    guard let location = self.viewModel.location else {return}
                    self.delegate?.locationDetailViewControllerDidTapMapButton(location)
                    self.scrollToButtonSv()
                    
                case .review:
                    guard let location = self.viewModel.location else {return }
                    let vm = WriteReviewViewModel(location)
                    let vc = WriteReviewViewController(WriteReviewView(), vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case .addToMyTrip:
                    self.viewModel.addToMyTrip()
                    
                case .removeFromMyTrip:
                    self.viewModel.removeFromMyTrip()
                    
                case .showDetailReview:
                    if
                        let location = self.viewModel.location,
                        let locationDetail = self.viewModel.locationDetail {
                        
                        let vm = ReviewViewModel(location, locationDetail)
                        let vc = ReviewViewController(ReviewView(), vm)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            }
            .store(in: &cancellables)
        
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
    
    private func scrollToButtonSv() {
        contentView.scrollToButtonSv()
    }
}
