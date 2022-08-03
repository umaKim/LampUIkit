//
//  MyCharacterViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//

import UIKit

class MyCharacterViewController: BaseViewContronller {

    private typealias DataSource = UITableViewDiffableDataSource<Section, GaugeData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, GaugeData>
    
    enum Section { case main }
    
    private let contentView = MyCharacterView()
    
    private var dataSource: DataSource?
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    private let viewModel: MyCharacterViewModel
    
    init(vm: MyCharacterViewModel) {
        self.viewModel = vm
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        updateSections()
        
        viewModel
            .notifyPublisher
            .sink { noti in
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
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {
            self.dataSource?.applySnapshotUsingReloadData(snapshot)
        })
    }
    
    private func setupDataSource() {
        contentView.tableView.delegate = self
        
        dataSource = .init(tableView: contentView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyCharacterViewTableViewCell.identifier, for: indexPath) as? MyCharacterViewTableViewCell else {return UITableViewCell()}
            cell.configure(with: GaugeData(name: "", rate: ""))
            return cell
        })
    }
}

extension MyCharacterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyCharacterViewTableViewHeaderCell.identifier) as? MyCharacterViewTableViewHeaderCell
        else {return nil}
        header.configure(with: CharacterData(characterName: "", level: "", image: "", averageStat: "", mileage: "", gaugeDatum: []))
        return header
    }
}

class GraphHeaderView: UIView {
        setupUI()
    private func setupUI() {
        let headerSv = UIStackView(arrangedSubviews: [titleLabel, numberLabel])
        headerSv.axis = .horizontal
        headerSv.distribution = .fill
        headerSv.alignment = .fill
        
        let totalSv = UIStackView(arrangedSubviews: [headerSv, graphView])
        totalSv.axis = .vertical
        totalSv.distribution = .equalSpacing
        totalSv.alignment = .fill
        
        totalSv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalSv)
        
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalSv.bottomAnchor.constraint(equalTo: bottomAnchor),
            totalSv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    */

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
}
