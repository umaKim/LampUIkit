//
//  MyPageViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//
import UmaBasicAlertKit
import UIKit

class MyPageViewController: BaseViewController<MyPageView, MyPageViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        
        navigationItem.leftBarButtonItems = [contentView.backButton]
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .logoutActions:
                    self.presentUmaActionAlert(title: "로그아웃 하시겠습니까?".localized,
                                               with: self.logoutAction, self.cancelAction)
                    
                case .deleteAccountActions:
                    self.presentUmaActionAlert(title: "회원 탈퇴 하시겠습니까?".localized,
                                               with: self.deleteAccountAction, self.cancelAction)
                case .back:
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .goBackToBeforeLoginPage:
                    self.changeRoot(StartPageViewController(StartPageView(), StartPageViewModel()))
                    
                case .myInfo(let info):
                    break
                    
                case .reload:
                    self.contentView.tableView.reloadData()
                }
        }
        .store(in: &cancellables)
    }
    
    private var logoutAction: UIAlertAction {
        return .init(title: "로그아웃".localized, style: .default, handler: {[weak self] action in
            guard let self = self else {return}
            self.viewModel.logout()
        })
    }
    
    private var deleteAccountAction: UIAlertAction {
        return .init(title: "계정 삭제".localized, style: .default, handler: {[weak self] action in
            guard let self = self else {return}
            self.viewModel.deleteAccount()
        })
    }
    
    private var cancelAction: UIAlertAction {
        return .init(title: "취소".localized, style: .cancel)
    }
}

extension MyPageViewController: MyReviewsViewControllerDelegate {
    func MyReviewsViewControllerDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier,
                                                     for: indexPath) as? MyPageTableViewCell
        else {return UITableViewCell()}
        cell.configure(with: viewModel.models[indexPath.row])
        return cell
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
        HapticManager.shared.feedBack(with: .medium)
        if viewModel.models[indexPath.item] == "나의 여행 후기" {
            let vc = MyReviewsViewController(MyReviewsView(), MyReviewsViewModel())
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else if viewModel.models[indexPath.item] == "로그아웃" {
            contentView.presentLogOutActions()
        } else if viewModel.models[indexPath.item] == "회원탈퇴" {
            contentView.presentDeleteAccountActions()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let myInfo = viewModel.myInfo else {return nil}
        let view = MyPageTableViewHeaderView(myInfo)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }
}
