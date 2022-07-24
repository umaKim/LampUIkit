//
//  MyTravelViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import UIKit

final

class MyTravelViewController: BaseViewContronller {

    private let contentView = MyTravelView()
    
    private let viewModel: MyTravelViewModel
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    init(vm: MyTravelViewModel) {
        self.viewModel = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "나의 여행"
        
        navigationItem.largeTitleDisplayMode = .always
        
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        
        navigationItem.rightBarButtonItems = [contentView.gearButton, contentView.arButton]
        navigationController?.setLargeTitleColor(.midNavy)
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .ar:
                    let vm = ARViewModel()
                    let vc = ARViewController(vm: vm)
                    self.present(vc, animated: true)
                    
                case .gear:
                    let vm = MyPageViewModel()
                    let vc = MyPageViewController(vm: vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.categoryButton.scrollIndicator(to: scrollView.contentOffset)
    }
}

extension MyTravelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTravelCell.identifier, for: indexPath) as? MyTravelCell
            else { return UICollectionViewCell() }
            cell.configure(models: viewModel.model.myTravel)
            return cell
            
        } else if indexPath.item == 1 {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell
            else { return UICollectionViewCell() }
            cell.configure(models: viewModel.model.favoriteTravel)
            return cell
            
        } else if indexPath.item == 2 {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedTravelCell.identifier, for: indexPath) as? CompletedTravelCell
            else { return UICollectionViewCell() }
            cell.configure(models: viewModel.model.completedTravel)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MyTravelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width, height: collectionView.frame.height)
    }
}
