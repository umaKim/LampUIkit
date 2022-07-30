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

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
