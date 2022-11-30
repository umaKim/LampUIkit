//
//  MyTravelCategoryView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import CombineCocoa
import Combine
import UIKit

enum MenuBarButtonAction: Actionable {
    case didTapMyTravel
    case didTapFavoritePlace
    case didTapCompletedTravel
}

final class MyTravelCategoryView: BaseView<MenuBarButtonAction> {
    private lazy var myTravelButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("나의 여행지".localized, for: .normal)
        bt.setTitleColor(UIColor.lightNavy, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return bt
    }()
    private lazy var favoritePlaceButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("찜한 장소".localized, for: .normal)
        bt.setTitleColor(UIColor.gray, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return bt
    }()
    private lazy var completedTravelButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("완료된 여행".localized, for: .normal)
        bt.setTitleColor(UIColor.gray, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return bt
    }()
    private lazy var selectionBarView: UIView = {
        let uv = UIView(frame: .init(x: 0, y: 56, width: UIScreen.main.width / 3, height: 3))
        uv.backgroundColor = .lightNavy
        return uv
    }()
    private let separatorView = DividerView()
    override init() {
        super.init()
        bind()
        setupUI()
    }
    private func bind() {
        myTravelButton.tapPublisher.sink {[weak self] _ in
            self?.sendAction(.didTapMyTravel)
        }
        .store(in: &cancellables)
        favoritePlaceButton.tapPublisher.sink {[weak self] _ in
            self?.sendAction(.didTapFavoritePlace)
        }
        .store(in: &cancellables)
        completedTravelButton.tapPublisher.sink {[weak self] _ in
            self?.sendAction(.didTapCompletedTravel)
        }
        .store(in: &cancellables)
    }
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [myTravelButton, favoritePlaceButton, completedTravelButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        [sv, separatorView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        addSubview(selectionBarView)
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
            selectionBarView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyTravelCategoryView {
    func selectItem(at index: Int) {
        animateIndicator(to: index)
    }
    func scrollIndicator(to contentOffset: CGPoint) {
        let buttons = [myTravelButton, favoritePlaceButton, completedTravelButton]
        let index = Int(contentOffset.x / frame.width)
        setAlpha(for: buttons[index])
        setSelectionBar(at: index)
    }
    private func setSelectionBar(at index: Int) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else {return}
            self.selectionBarView.frame.origin.x = (UIScreen.main.width / 3) * CGFloat(index)
        } completion: { _ in }
    }
    private func setAlpha(for button: UIButton) {
        self.myTravelButton.alpha = 0.5
        self.myTravelButton.setTitleColor(.gray, for: .normal)
        self.favoritePlaceButton.alpha = 0.5
        self.favoritePlaceButton.setTitleColor(.gray, for: .normal)
        self.completedTravelButton.alpha = 0.5
        self.completedTravelButton.setTitleColor(.gray, for: .normal)
        button.alpha = 1.0
        button.setTitleColor(.lightNavy, for: .normal)
    }
    private func animateIndicator(to index: Int) {
        var button: UIButton
        switch index {
        case 0:
            button = myTravelButton
        case 1:
            button = favoritePlaceButton
        case 2:
            button = completedTravelButton
        default:
            button = myTravelButton
        }
        setAlpha(for: button)
    }
}
