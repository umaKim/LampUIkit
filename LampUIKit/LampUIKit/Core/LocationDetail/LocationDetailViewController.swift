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
    
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    private let viewModel: LocationDetailViewModel
    
    weak var delegate: LocationDetailViewControllerDelegate?
    
    init(vm: LocationDetailViewModel) {
        self.viewModel = vm
        super.init()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    }
    
    }
}
