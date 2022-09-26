//
//  CategoryButtonView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//
import CombineCocoa
import Combine
import UIKit

enum CategoryButtonViewAction: Actionable {
    case all
    case recommend
    case travel
    case notVisit
}

class CategoryButtonView: BaseView<CategoryButtonViewAction> {
    
    private let allButton: RectangleTextButton = {
        let bt = RectangleTextButton("전국", background: .white, textColor: .lightNavy, fontSize: 15)
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.gray.cgColor
        return bt
    }()
    
    private let recommendOrderButton: RectangleTextButton = {
        let bt = RectangleTextButton("추천순", background: .white, textColor: .lightNavy, fontSize: 15)
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.gray.cgColor
        return bt
    }()
    
    private let travelButton: RectangleTextButton = {
        let bt = RectangleTextButton("여행지", background: .white, textColor: .lightNavy, fontSize: 15)
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.gray.cgColor
        return bt
    }()
    
    private let notVisitButton: RectangleTextButton = {
        let bt = RectangleTextButton("미방문", background: .white, textColor: .lightNavy, fontSize: 15)
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.gray.cgColor
        return bt
    }()
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    private func bind() {
        allButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.sendAction(.all)
        }
        .store(in: &cancellables)
        
        recommendOrderButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.sendAction(.recommend)
        }
        .store(in: &cancellables)
        
        travelButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.sendAction(.travel)
        }
        .store(in: &cancellables)
        
        notVisitButton.tapPublisher.sink {[weak self] _ in
            guard let self = self else {return}
            self.sendAction(.notVisit)
        }.store(in: &cancellables)
    }
    
    private func setupUI() {
        
        let sv = UIStackView(arrangedSubviews: [allButton,
                                                recommendOrderButton,
                                                travelButton,
                                                notVisitButton])
        sv.axis = .horizontal
        sv.spacing = 11
        sv.distribution = .fillEqually
        sv.alignment = .fill
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(sv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
