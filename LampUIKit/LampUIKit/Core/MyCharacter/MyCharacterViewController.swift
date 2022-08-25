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
    
    weak var delegate: MyCharacterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        updateSections()
        
        navigationItem.rightBarButtonItems = [contentView.dismissButton]
        
        contentView
            .actionPublisher
            .sink {[unowned self] action in
                switch action {
                case .dismiss:
                    self.delegate?.myCharacterViewControllerDidTapDismiss()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[unowned self] noti in
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
        dataSource?.apply(snapshot, animatingDifferences: true, completion: { [unowned self] in
            self.dataSource?.applySnapshotUsingReloadData(snapshot)
        })
    }
    
    private func setupDataSource() {
        contentView.tableView.delegate = self
        
        dataSource = .init(tableView: contentView.tableView, cellProvider: {[unowned self] tableView, indexPath, itemIdentifier in
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: MyCharacterViewTableViewCell.identifier, for: indexPath) as? MyCharacterViewTableViewCell,
                let data = viewModel.characterData
            else {return UITableViewCell()}
            cell.configure(with: data.gaugeDatum[indexPath.row])
            return cell
        })
    }
}

extension MyCharacterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyCharacterViewTableViewHeaderCell.identifier) as? MyCharacterViewTableViewHeaderCell,
            let data = viewModel.characterData
        else { return nil }
        header.configure(with: data)
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class HorizontalFillBar: UIProgressView {
    private let height: CGFloat
    
    init(
        height: CGFloat,
        fillerColor: UIColor,
        trackColor: UIColor
    ) {
        self.height = height
        super.init(frame: .zero)
        
        progressViewStyle = .bar
    
        progressTintColor = fillerColor
        trackTintColor = trackColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
        layer.cornerRadius = height / 2
        clipsToBounds = true
    }
}
