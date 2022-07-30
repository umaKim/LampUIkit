//
//  LampSpotViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//
import Combine
import UIKit

class LampSpotViewController: BaseViewContronller {
    
    private let contentView = LampSpotView()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    private let viewModel: LampSpotViewModel
    
    init(vm: LampSpotViewModel) {
        self.viewModel = vm
        super.init()
        
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [contentView.bellButton,
                                              contentView.arButton]
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
            switch action {
            case .ar:
                self?.present(ARViewController(vm: ARViewModel()), animated: true)
            case .bell:
                let nav = UINavigationController(rootViewController: UIViewController())
                self?.navigationController?.pushViewController(nav, animated: true)
            }
        }
        .store(in: &cancellables)
    }
}

extension LampSpotViewController: MyMapCollectionViewCellDelegate {
    func didSelectMyLampImage() {
        //TODO: Move to new page
        let vm = LampSpotMapViewModel()
        let vc = LampSpotMapViewController(vm: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LampSpotViewController: RecommendationCollectionViewCellDelegate {
    func recommendationCollectionViewCellDidSelect(itemAt indexPath: IndexPath) {
        let vm = LocationDetailViewModel()
        let vc = LocationDetailViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LampSpotViewController: PopularLampSpotCollectionViewCellDelegate {
    func popularLampSpotCollectionViewCellDidTap() {
        let vm = LocationDetailViewModel()
        let vc = LocationDetailViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LampSpotViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyMapCollectionViewCell.identifier, for: indexPath) as? MyMapCollectionViewCell else {return UICollectionViewCell() }
            cell.delegate = self
            return cell
        } else if indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, for: indexPath) as? RecommendationCollectionViewCell else {return UICollectionViewCell() }
            cell.models = ["nice", "good", "paw", "nice", "good", "paw", "nice", "good", "paw"]
            cell.delegate = self
            return cell
        } else if indexPath.item == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularLampSpotCollectionViewCell.identifier, for: indexPath) as? PopularLampSpotCollectionViewCell else {return UICollectionViewCell() }
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}

extension LampSpotViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return .init(width: UIScreen.main.width, height: UIScreen.main.width)
        } else if indexPath.item == 1 {
            return .init(width: UIScreen.main.width, height: UIScreen.main.width/2.5)
        } else if indexPath.item == 2 {
            return .init(width: UIScreen.main.width, height: UIScreen.main.width)
        }
        return .init(width: 0, height: 0)
    }
}
