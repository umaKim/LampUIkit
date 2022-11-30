//
//  MyCharacterViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//

import UIKit

protocol MyCharacterViewControllerDelegate: AnyObject {
    func myCharacterViewControllerDidTapDismiss()
}

class MyCharacterViewController: BaseViewController<MyCharacterView, MyCharacterViewModel> {
    private typealias DataSource = UITableViewDiffableDataSource<Section, GaugeData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, GaugeData>
    enum Section { case main }
    private var dataSource: DataSource?
    weak var delegate: MyCharacterViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupDataSource()
        updateSections()
        navigationItem.leftBarButtonItems = [contentView.dismissButton]
        navigationItem.rightBarButtonItems = [contentView.gearButton]
        bind()
    }
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                HapticManager.shared.feedBack(with: .medium)
                switch action {
                case .gear:
                    let viewModel = MyPageViewModel()
                    let viewController = MyPageViewController(MyPageView(), viewModel)
                    self.navigationController?.pushViewController(viewController, animated: true)
                case .dismiss:
                    self.delegate?.myCharacterViewControllerDidTapDismiss()
                }
            }
            .store(in: &cancellables)
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .reload:
                    self.updateSections()
                }
            }
            .store(in: &cancellables)
    }
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.characterData?.gaugeDatum ?? [])
        dataSource?.apply(snapshot, animatingDifferences: true, completion: { [weak self] in
            guard let self = self else { return }
            self.dataSource?.applySnapshotUsingReloadData(snapshot)
        })
    }
    private func setupDataSource() {
        contentView.tableView.delegate = self
        dataSource = .init(
            tableView: contentView.tableView,
            cellProvider: {[weak self] tableView, indexPath, itemIdentifier in
            guard let self = self else { return nil }
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: MyCharacterViewTableViewCell.identifier,
                    for: indexPath
                ) as? MyCharacterViewTableViewCell,
                let data = self.viewModel.characterData
            else {return UITableViewCell()}
            cell.configure(with: data.gaugeDatum[indexPath.row])
            return cell
        })
    }
}

// MARK: - UITableViewDelegate
extension MyCharacterViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: MyCharacterViewTableViewHeaderCell.identifier
            ) as? MyCharacterViewTableViewHeaderCell,
            let data = viewModel.characterData
        else { return nil }
        header.configure(with: data)
        return header
    }
}
