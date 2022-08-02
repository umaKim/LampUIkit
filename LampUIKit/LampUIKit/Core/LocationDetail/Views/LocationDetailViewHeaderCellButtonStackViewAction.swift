//
//  LocationDetailViewHeaderCellButtonStackViewAction.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import Combine
import CombineCocoa
import UIKit

enum LocationDetailViewHeaderCellButtonStackViewAction {
    case save
    case ar
    case review
    case share
}

class LocationDetailViewHeaderCellButtonStackView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LocationDetailViewHeaderCellButtonStackViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private let saveButton: UIButton = {
        return .buttonMaker(image: UIImage(named: "detailSave"),
                            imagePadding: 12,
                            subTitle: "저장하기")
    }()
    
    private let arButton: UIButton = {
        return .buttonMaker(image: .camera,
                            imagePadding: 12,
                            subTitle: "AR")
    }()
    
    private let reviewButton: UIButton = {
        return .buttonMaker(image: UIImage(named: "detailReview"),
                            imagePadding: 12,
                            subTitle: "후기쓰기")
    }()
    
    private let shareButton: UIButton = {
        return .buttonMaker(image: UIImage(named: "detailShare"),
                            imagePadding: 12,
                            subTitle: "공유하기")
    }()
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        saveButton.tapPublisher.sink { _ in
            self.actionSubject.send(.save)
        }
        .store(in: &cancellables)
        
        arButton.tapPublisher.sink { _ in
            self.actionSubject.send(.ar)
        }
        .store(in: &cancellables)
        
        reviewButton.tapPublisher.sink { _ in
            self.actionSubject.send(.review)
        }
        .store(in: &cancellables)
        
        shareButton.tapPublisher.sink { _ in
            self.actionSubject.send(.share)
        }
        .store(in: &cancellables)
    }
    
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [saveButton, arButton, reviewButton, shareButton])
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
