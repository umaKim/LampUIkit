//
//  RecommendedLocationViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/25.
//

import UIKit

protocol RecommendedLocationViewControllerDelegate: AnyObject {
    func recommendedLocationViewControllerDidTapSearch()
    func recommendedLocationViewControllerDidTapMapPin(location: RecommendedLocation)
    func recommendedLocationViewControllerDidTapMyCharacter()
    func recommendedLocationViewControllerDidTapMyTravel()
    func recommendedLocationViewControllerDidTapNavigation(location: RecommendedLocation)
}

class RecommendedLocationViewController: BaseViewContronller {
   
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, RecommendedLocation>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RecommendedLocation>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    private(set) var contentView = RecommendedLocationView()
    
    private let viewModel: RecommendedLocationViewmodel
    
    init(_ vm: RecommendedLocationViewmodel) {
        self.viewModel = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    weak var delegate: RecommendedLocationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.collectionView.delegate = self
        
        configureCollectionView()
        updateSections()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                HapticManager.shared.feedBack(with: .heavy)
                switch action {
                case .search:
                    let vc = SearchViewController(vm: SearchViewModel())
                    vc.delegate = self
                    self?.delegate?.recommendedLocationViewControllerDidTapSearch()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                case .myCharacter:
                    let vc = MyCharacterViewController(vm: MyCharacterViewModel())
                    vc.delegate = self
                    self?.delegate?.recommendedLocationViewControllerDidTapMyCharacter()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                case .myTravel:
                    let vc = MyTravelViewController(vm: MyTravelViewModel())
                    vc.delegate = self
                    self?.delegate?.recommendedLocationViewControllerDidTapMyTravel()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .receive(on: RunLoop.main)
            .sink {[weak self] noti in
                switch noti {
                case .updateAddress(let address):
                    self?.contentView.updateCustomNavigationBarTitle(address)
                    
                case .reload:
                    self?.updateSections()
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func setUpNavigationView(_ text: String = "") {
        let titleView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: navigationController?.navigationBar.frame.width ?? 0,
                                             height: navigationController?.navigationBar.frame.height ?? 25))
        let label = UILabel(frame: CGRect(x: 10, y: 13, width: titleView.frame.width, height: titleView.frame.height))
        label.text = text
        label.font = .robotoBold(18)
        label.textColor = .darkNavy
        label.sizeToFit()
        label.numberOfLines = 0
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
}

extension RecommendedLocationViewController {
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.locations)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureCollectionView() {
        contentView.collectionView.delegate = self
        
        dataSource = DataSource(collectionView: contentView.collectionView,
                                cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRecommendationCollectionViewCell.identifier, for: indexPath) as? SearchRecommendationCollectionViewCell
            else { return UICollectionViewCell() }
            cell.tag = indexPath.item
            if let item = self?.viewModel.locations[indexPath.item] {
                cell.configure(with: item)
            }
            cell.delegate = self
            return cell
        })
    }
}

extension RecommendedLocationViewController: LocationDetailViewControllerDelegate {
    func locationDetailViewControllerDidTapNavigate(_ location: RecommendedLocation) {
        self.delegate?.recommendedLocationViewControllerDidTapNavigation(location: location)
    }
    
    func locationDetailViewControllerDidTapDismissButton() {
        
    }
    
    func locationDetailViewControllerDidTapMapButton(_ location: RecommendedLocation) {
        self.delegate?.recommendedLocationViewControllerDidTapMapPin(location: location)
    }
    
    func locationDetailViewControllerDidTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecommendedLocationViewController: SearchViewControllerDelegate {
    func searchViewControllerDidTapNavigation(at location: RecommendedLocation) {
        self.delegate?.recommendedLocationViewControllerDidTapNavigation(location: location)
    }
    
    func searchViewControllerDidTapDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchViewControllerDidTapMapPin(at location: RecommendedLocation) {
        self.delegate?.recommendedLocationViewControllerDidTapMapPin(location: location)
    }
    
    func searchBarDidTap() {
        
    }
}

extension RecommendedLocationViewController: MyCharacterViewControllerDelegate {
    func myCharacterViewControllerDidTapDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecommendedLocationViewController: MyTravelViewControllerDelegate {
    func myTravelViewControllerDidTapNavigation(_ location: RecommendedLocation) {
        delegate?.recommendedLocationViewControllerDidTapNavigation(location: location)
    }
    
    func myTravelViewControllerDidTapMapButton(_ location: RecommendedLocation) {
        delegate?.recommendedLocationViewControllerDidTapMapPin(location: location)
    }
    
    func myTravelViewControllerDidTapDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecommendedLocationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = LocationDetailViewModel(viewModel.locations[indexPath.item])
        let vc = LocationDetailViewController(vm: vm)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RecommendedLocationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width - 32, height: 175)
    }
}

extension RecommendedLocationViewController: SearchRecommendationCollectionViewCellDelegate {
    func didTapCancelThisLocationButton(at index: Int, _ location: RecommendedLocation) {
        viewModel.deleteFromMyTrip(at: index, location)
    }
    
    func didTapFavoriteButton(at index: Int, _ location: RecommendedLocation) {
        viewModel.save(index)
    }
    
    func didTapSetThisLocationButton(at index: Int, _ location: RecommendedLocation) {
        viewModel.postAddToMyTrip(at: index, location)
    }
    
    func didTapMapPin(location: RecommendedLocation) {
        delegate?.recommendedLocationViewControllerDidTapMapPin(location: location)
    }
}
