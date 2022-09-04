//
//  LocationDetailViewHeaderCellButtonStackViewAction.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import SkeletonView
import Combine
import CombineCocoa
import UIKit

enum LocationDetailViewHeaderCellButtonStackViewAction {
    case save
    case ar
    case map
    case navigation
    case review
}

class LocationDetailViewHeaderCellButtonStackView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LocationDetailViewHeaderCellButtonStackViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private lazy var saveButton: UIButton = {
        return .buttonMaker(image: self.isSaved ? UIImage(named: "favorite_saved") : UIImage(named: "detailSave"),
                            imagePadding: 12,
                            subTitle: "저장하기")
    }()
    
    private let arButton: UIButton = {
        return .buttonMaker(image: .camera,
                            imagePadding: 12,
                            subTitle: "AR")
    }()
    
    private let mapButton: UIButton = {
        return .buttonMaker(image: UIImage(named: "map"),
                            imagePadding: 12,
                            subTitle: "지도보기")
    }()
    
    private let navigationButton: UIButton = {
        return .buttonMaker(image: UIImage(systemName: "person"),
                            imagePadding: 12,
                            subTitle: "길안내")
    }()
    
    private let reviewButton: UIButton = {
        return .buttonMaker(image: UIImage(named: "detailReview"),
                            imagePadding: 12,
                            subTitle: "후기쓰기")
    }()
    
    private var isSaved: Bool = false
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    public func configure(_ isSaved: Bool) {
        self.isSaved = isSaved
        
        saveButton.setImage(isSaved ? UIImage(named: "favorite_saved") : UIImage(named: "detailSave"), for: .normal)
    }
    
    public func showSkeleton() {
        saveButton.showLoading()
        arButton.showLoading()
        mapButton.showLoading()
        reviewButton.showLoading()
    }
    
    public func hideSkeleton() {
        saveButton.hideLoading()
        arButton.hideLoading()
        mapButton.hideLoading()
        reviewButton.hideLoading()
    }
    
    private func bind() {
        saveButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.isSaved.toggle()
                if self.isSaved {
                    self.saveButton.setImage(UIImage(named: "favorite_saved"), for: .normal)
                    
                } else {
                    self.saveButton.setImage(UIImage(named: "detailSave"), for: .normal)
                }
                self.actionSubject.send(.save)
            }
            .store(in: &cancellables)
        
        arButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.ar)
            }
            .store(in: &cancellables)
        
        mapButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.map)
            }
            .store(in: &cancellables)
        
        navigationButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.navigation)
            }
            .store(in: &cancellables)
        
        reviewButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.review)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [saveButton,
                                                arButton,
                                                mapButton,
//                                                navigationButton,
                                                reviewButton])
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
            uv.isSkeletonable = true
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
